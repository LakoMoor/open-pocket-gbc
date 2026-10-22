package io.github.lakomoor.openpocket

import android.content.Context
import android.hardware.usb.UsbManager
import android.net.Uri
import android.provider.OpenableColumns

/** What goes where in the board's 8 MB flash (the same layout as flash.sh). */
data class FlashPart(val name: String, val addr: Int, val data: ByteArray)

object Flasher {
    const val BITSTREAM = 0x000000
    const val FIRMWARE = 0x100000
    const val GAMES = 0x200000

    /** Sorts picked files by name: .fs or *fpga*.bin -> bitstream, *fw*.bin -> firmware, games*.bin -> games. */
    fun parts(ctx: Context, uris: List<Uri>): List<FlashPart> = uris.map { u ->
        val name = ctx.contentResolver.query(u, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use {
            if (it.moveToFirst()) it.getString(0) else null
        } ?: u.lastPathSegment ?: "file"
        val bytes = ctx.contentResolver.openInputStream(u)!!.use { it.readBytes() }
        val n = name.lowercase()
        when {
            n.endsWith(".fs") -> FlashPart(name, BITSTREAM, fsToBin(bytes.toString(Charsets.US_ASCII)))
            "fpga" in n || "gbc_top" in n -> FlashPart(name, BITSTREAM, bytes)
            "game" in n -> FlashPart(name, GAMES, bytes)
            "fw" in n || "firmware" in n -> FlashPart(name, FIRMWARE, bytes)
            else -> throw Exception("$name: name it *.fs, *fpga*.bin, *fw*.bin or games*.bin")
        }
    }.sortedBy { it.addr }

    fun check(parts: List<FlashPart>) {
        for (p in parts) {
            val limit = when (p.addr) { BITSTREAM -> FIRMWARE; FIRMWARE -> GAMES; else -> 0x600000 } - p.addr
            if (p.data.size > limit) throw Exception("${p.name} is larger than its flash area (${limit / 1024} KB)")
            if (p.data.isEmpty()) throw Exception("${p.name} is empty")
        }
    }

    /** Writes the parts over JTAG and reboots the board. */
    fun run(ctx: Context, parts: List<FlashPart>, progress: (String, Float) -> Unit): String {
        check(parts)
        val mgr = ctx.getSystemService(Context.USB_SERVICE) as UsbManager
        val dev = mgr.deviceList.values.firstOrNull { it.vendorId == Board.VID && it.productId == Board.PID }
            ?: throw Exception("plug in the board (USB OTG)")
        if (!mgr.hasPermission(dev)) { Board.connect(ctx); throw Exception("allow USB access, then try again") }
        val j = Jtag.open(mgr, dev)
        var done = false
        try {
            progress("Connecting", 0f)
            val jedec = j.beginFlash()
            Board.appendLog("JTAG: GW2AR-18, flash %06x\n".format(jedec))
            for (p in parts) {
                j.writeFlash(p.addr, p.data) { what, f -> progress("$what ${p.name}", f) }
                Board.appendLog("JTAG: ${p.name} written at 0x%06x (%d bytes)\n".format(p.addr, p.data.size))
            }
            progress("Restarting", 1f)
            j.reload()
            done = true
            return "Written: " + parts.joinToString(", ") { it.name } + ". The board restarted."
        } finally {
            if (!done) try { j.reload() } catch (_: Exception) {}   // boot whatever the flash holds
            j.close()
        }
    }
}
