package io.github.lakomoor.openpocket

import android.graphics.Bitmap
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * The live picture of the board: the firmware streams the Game Boy frame (changed rows, PackBits)
 * and the menu text layers over the USB-UART at ~2 Mbaud (see scr_poll in fw/src/main.c). This
 * decodes the packets and composes what the HDMI output shows (game 3x in 720 x 480 with the OSD
 * on top) and what the LCD shows.
 */
object LiveScreen {
    private val fb = ShortArray(160 * 144)
    private val osd = ShortArray(42 * 24)
    private val lcd = ShortArray(16 * 12)
    @Volatile private var osdFlags = 0
    @Volatile private var lcdFlags = 0
    private var gbc = 1; private var gbcRaw = 0
    private val dmg = intArrayOf(0xF8F8F8, 0xA8A8A8, 0x585858, 0x101010)
    var font: IntArray = IntArray(128 * 8)

    private val _frame = MutableStateFlow(0)
    val frame = _frame.asStateFlow()            // bumps on every complete frame or layer change
    @Volatile var fps = 0f; private set
    private var fpsT = 0L; private var fpsN = 0

    private val PAL = intArrayOf(0x101010, 0x000000, 0x0F380F, 0x242424, 0x3C3C3C, 0x7A7A7A, 0xBEBEBE, 0xFFFFFF,
        0x3A6FF0, 0x9BBC0F, 0xF5C518, 0xE5483C, 0x306230, 0x0E1A33, 0x8BAC0F, 0x000000)

    // ---- packets: 0x00, type, u16 length, payload
    fun packet(type: Char, p: ByteArray, n: Int) {
        when (type) {
            'P' -> if (n >= 14) {
                gbc = p[0].toInt(); gbcRaw = p[1].toInt()
                for (i in 0 until 4) dmg[i] = ((p[2 + i * 3].toInt() and 255) shl 16) or ((p[3 + i * 3].toInt() and 255) shl 8) or (p[4 + i * 3].toInt() and 255)
            }
            'O' -> { osdFlags = p[0].toInt(); if (n >= 1 + osd.size * 2) cells(p, osd); _frame.value++ }
            'L' -> { lcdFlags = p[0].toInt(); if (n >= 1 + lcd.size * 2) cells(p, lcd); _frame.value++ }
            'G' -> row(p, n)
            'F' -> {
                _frame.value++
                fpsN++
                val t = System.currentTimeMillis()
                if (t - fpsT >= 1000) { fps = fpsN * 1000f / (t - fpsT); fpsN = 0; fpsT = t }
            }
        }
    }

    private fun cells(p: ByteArray, dst: ShortArray) {
        for (i in dst.indices) dst[i] = ((p[1 + i * 2].toInt() and 255) or ((p[2 + i * 2].toInt() and 255) shl 8)).toShort()
    }

    private fun row(p: ByteArray, n: Int) {
        val y = p[0].toInt() and 255
        if (y >= 144) return
        var i = 1; var x = 0
        val base = y * 160
        while (i < n && x < 160) {
            val c = p[i++].toInt() and 255
            if (c < 128) {
                repeat(c + 1) {
                    if (i + 1 < n && x < 160) { fb[base + x++] = ((p[i].toInt() and 255) or ((p[i + 1].toInt() and 255) shl 8)).toShort(); i += 2 }
                }
            } else {
                if (i + 1 >= n) break
                val v =((p[i].toInt() and 255) or ((p[i + 1].toInt() and 255) shl 8)).toShort(); i += 2
                repeat(c - 126) { if (x < 160) fb[base + x++] = v }
            }
        }
    }

    // the firmware's pix_rgb: DMG shades through the palette, GBC raw or colour-corrected
    private fun rgb(v: Int): Int {
        if (gbc == 0) return dmg[v and 3]
        val r5 = v and 31; val g5 = (v shr 5) and 31; val b5 = (v shr 10) and 31
        if (gbcRaw != 0) return ((r5 shl 3 or (r5 shr 2)) shl 16) or ((g5 shl 3 or (g5 shr 2)) shl 8) or (b5 shl 3 or (b5 shr 2))
        val r = (r5 * 26 + g5 * 4 + b5 * 2) shr 2; val g = (g5 * 24 + b5 * 8) shr 2; val b = (r5 * 6 + g5 * 4 + b5 * 22) shr 2
        return (minOf(r, 255) shl 16) or (minOf(g, 255) shl 8) or minOf(b, 255)
    }

    private fun drawCells(px: IntArray, w: Int, h: Int, src: ShortArray, cols: Int, rows: Int, ox: Int, oy: Int, sc: Int) {
        for (cy in 0 until rows) for (cx in 0 until cols) {
            val v = src[cy * cols + cx].toInt() and 0xFFFF
            val attr = v shr 8; val ch = v and 0xFF; val code = ch and 0x7F; val ext = ch and 0x80 != 0
            for (py in 0 until 10) {
                val fy = py - 1
                val bits = if (fy < 0 || fy > 7) (if (ext) font[code * 8 + (if (fy < 0) 0 else 7)] else 0) else font[code * 8 + fy]
                for (pxx in 0 until 8) {
                    val ci = if ((bits shr (7 - pxx)) and 1 == 1) attr and 15 else attr shr 4
                    if (ci == 0) continue                          // transparent: the game shows through
                    val c = (0xFF shl 24) or PAL[ci]
                    for (sy in 0 until sc) for (sx in 0 until sc) {
                        val x = ox + (cx * 8 + pxx) * sc + sx; val y = oy + (cy * 10 + py) * sc + sy
                        if (x in 0 until w && y in 0 until h) px[y * w + x] = c
                    }
                }
            }
        }
    }

    private val hdmiPx = IntArray(720 * 480)
    private val lcdPx = IntArray(128 * 128)

    /** The HDMI picture: the game 3x at (120, 24), the 42 x 24 OSD at 16 x 20 px per cell. */
    fun renderHdmi(bmp: Bitmap) {
        val dim = osdFlags and 3 == 3
        java.util.Arrays.fill(hdmiPx, 0xFF000000.toInt())
        for (y in 0 until 144) for (x in 0 until 160) {
            var c = rgb(fb[y * 160 + x].toInt())
            if (dim) c = ((c shr 16 and 255) * 2 / 5 shl 16) or ((c shr 8 and 255) * 2 / 5 shl 8) or ((c and 255) * 2 / 5)
            val argb = (0xFF shl 24) or c
            val o = (24 + y * 3) * 720 + 120 + x * 3
            for (k in 0 until 3) { hdmiPx[o + k] = argb; hdmiPx[o + 720 + k] = argb; hdmiPx[o + 1440 + k] = argb }
        }
        if (osdFlags and 1 != 0) drawCells(hdmiPx, 720, 480, osd, 42, 24, 24, 0, 2)
        bmp.setPixels(hdmiPx, 0, 720, 0, 0, 720, 480)
    }

    /** The game alone, scaled up by [sc] (for screenshots). */
    fun renderGame(sc: Int): Bitmap {
        val px = IntArray(160 * sc * 144 * sc)
        for (y in 0 until 144 * sc) for (x in 0 until 160 * sc) px[y * 160 * sc + x] = (0xFF shl 24) or rgb(fb[(y / sc) * 160 + x / sc].toInt())
        return Bitmap.createBitmap(px, 160 * sc, 144 * sc, Bitmap.Config.ARGB_8888)
    }

    /** Saves the game (3x) and the HDMI picture (with the menu) to Pictures/OpenPocket; returns the name. */
    fun saveShot(ctx: android.content.Context): String {
        val name = "openpocket_" + java.text.SimpleDateFormat("yyyyMMdd_HHmmss", java.util.Locale.US).format(java.util.Date())
        val hdmi = Bitmap.createBitmap(720, 480, Bitmap.Config.ARGB_8888).also { renderHdmi(it) }
        for ((suffix, bmp) in listOf("" to renderGame(3), "_hdmi" to hdmi)) {
            val v = android.content.ContentValues().apply {
                put(android.provider.MediaStore.Images.Media.DISPLAY_NAME, "$name$suffix.png")
                put(android.provider.MediaStore.Images.Media.MIME_TYPE, "image/png")
                if (android.os.Build.VERSION.SDK_INT >= 29) put(android.provider.MediaStore.Images.Media.RELATIVE_PATH, "Pictures/OpenPocket")
            }
            val uri = ctx.contentResolver.insert(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI, v) ?: error("no media store")
            ctx.contentResolver.openOutputStream(uri)!!.use { bmp.compress(Bitmap.CompressFormat.PNG, 100, it) }
        }
        return name
    }

    /** The LCD picture: the game fitted to 128 x 115 (centred), the 16 x 12 menu text on top. */
    fun renderLcd(bmp: Bitmap) {
        java.util.Arrays.fill(lcdPx, 0xFF000000.toInt())
        val dim = osdFlags and 3 == 3
        for (y in 0 until 115) for (x in 0 until 128) {
            var c = rgb(fb[(y * 144 / 115) * 160 + x * 160 / 128].toInt())
            if (dim) c = ((c shr 16 and 255) * 2 / 5 shl 16) or ((c shr 8 and 255) * 2 / 5 shl 8) or ((c and 255) * 2 / 5)
            lcdPx[(y + 6) * 128 + x] = (0xFF shl 24) or c
        }
        if (osdFlags and 1 != 0) drawCells(lcdPx, 128, 128, lcd, 16, 12, 0, 4, 1)
        bmp.setPixels(lcdPx, 0, 128, 0, 0, 128, 128)
    }
}
