package io.github.lakomoor.openpocket

import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbEndpoint
import android.hardware.usb.UsbManager
import java.io.ByteArrayOutputStream

/**
 * Writes the Tang Nano 20K's SPI flash over JTAG, the way openFPGALoader does it
 * (`openFPGALoader -b tangnano20k -f`), from a phone over USB OTG.
 *
 * The on-board debugger is an FT2232-compatible chip: its port A runs MPSSE (JTAG), port B is
 * the UART that [Board] uses, so both work at the same time. On the GW2AR-18 the flash is reached
 * through JTAG instruction 0x16 once the SRAM is erased: each DR scan is one SPI transaction,
 * bit-reversed, with the data coming back one bit late. RELOAD (0x3C) then boots the new
 * bitstream.
 */
class Jtag private constructor(
    private val conn: UsbDeviceConnection,
    private val epOut: UsbEndpoint,
    private val epIn: UsbEndpoint,
) {
    companion object {
        const val GW2AR18_IDCODE = 0x0000081B
        private const val IF_A = 1                // FTDI interface index of port A

        fun open(mgr: UsbManager, dev: UsbDevice): Jtag {
            val intf = dev.getInterface(0)
            val conn = mgr.openDevice(dev) ?: throw Exception("can't open the USB device")
            if (!conn.claimInterface(intf, true)) { conn.close(); throw Exception("JTAG port is busy") }
            var o: UsbEndpoint? = null; var i: UsbEndpoint? = null
            for (k in 0 until intf.endpointCount) {
                val e = intf.getEndpoint(k)
                if (e.type != UsbConstants.USB_ENDPOINT_XFER_BULK) continue
                if (e.direction == UsbConstants.USB_DIR_OUT) o = e else i = e
            }
            if (o == null || i == null) { conn.close(); throw Exception("no JTAG endpoints") }
            return Jtag(conn, o, i).also { it.initMpsse() }
        }

        fun rev(b: Int): Int {
            var x = b and 0xFF
            x = (x and 0xF0 ushr 4) or (x and 0x0F shl 4)
            x = (x and 0xCC ushr 2) or (x and 0x33 shl 2)
            x = (x and 0xAA ushr 1) or (x and 0x55 shl 1)
            return x
        }
    }

    // ------------------------------------------------------------ FTDI / MPSSE
    private val q = ByteArrayOutputStream()
    private var expect = 0                        // bytes the queued commands will return

    private fun ctrl(req: Int, value: Int) {
        if (conn.controlTransfer(0x40, req, value, IF_A, null, 0, 1000) < 0) throw Exception("FTDI control $req failed")
    }

    private fun initMpsse() {
        ctrl(0, 0)                                // reset
        ctrl(9, 1)                                // latency timer 1 ms
        ctrl(0x0B, 0x0000)                        // bitmode reset
        ctrl(0x0B, 0x0200)                        // MPSSE
        ctrl(0, 1); ctrl(0, 2)                    // purge rx / tx
        drain()
        // bad-command check: the chip answers 0xFA 0xAA when MPSSE is up
        put(0xAA); expect += 2
        val r = flush()
        if (r.size < 2 || r[0].toInt() and 0xFF != 0xFA) throw Exception("the debugger did not enter MPSSE mode")
        // 60 MHz base, no adaptive / 3-phase clocking, no loopback; TCK TDI TMS out, TMS high
        put(0x8A, 0x97, 0x8D, 0x85, 0x80, 0x08, 0x0B, 0x82, 0x08, 0x0B)
        setClock(6_000_000)
        flush()
        state = Tap.UNKNOWN
        reset()
    }

    private fun setClock(hz: Int) {
        val presc = ((60_000_000 / hz) - 1) / 2
        put(0x86, presc and 0xFF, presc shr 8)
    }

    private fun put(vararg b: Int) { for (x in b) q.write(x) }

    private fun drain() {
        val buf = ByteArray(epIn.maxPacketSize.coerceAtLeast(64))
        while (conn.bulkTransfer(epIn, buf, buf.size, 20) > 2) {}
    }

    /** Sends the queued commands and returns the bytes they read back (status bytes removed). */
    private fun flush(): ByteArray {
        val data = q.toByteArray(); q.reset()
        var off = 0
        while (off < data.size) {
            val n = minOf(4096, data.size - off)
            val w = conn.bulkTransfer(epOut, data, off, n, 2000)
            if (w <= 0) throw Exception("USB write failed")
            off += w
        }
        val want = expect; expect = 0
        if (want == 0) return ByteArray(0)
        val out = ByteArrayOutputStream()
        val mps = epIn.maxPacketSize
        val buf = ByteArray(mps * 8)
        var idle = 0
        while (out.size() < want) {
            val n = conn.bulkTransfer(epIn, buf, buf.size, 1000)
            if (n <= 2) { if (++idle > 200) throw Exception("JTAG read timeout"); continue }
            // every packet starts with two modem status bytes
            var p = 0
            while (p < n) {
                val len = minOf(mps, n - p)
                if (len > 2) out.write(buf, p + 2, len - 2)
                p += len
            }
        }
        return out.toByteArray().copyOf(want)
    }

    fun close() { try { conn.close() } catch (_: Exception) {} }

    // ------------------------------------------------------------ TAP
    private enum class Tap { RESET, IDLE, SEL_DR, CAP_DR, SHIFT_DR, EXIT1_DR, PAUSE_DR, EXIT2_DR, UPD_DR,
        SEL_IR, CAP_IR, SHIFT_IR, EXIT1_IR, PAUSE_IR, EXIT2_IR, UPD_IR, UNKNOWN }
    private var state = Tap.UNKNOWN
    private val tmsBits = ArrayList<Int>()

    private fun tms(bit: Int) { tmsBits += bit }

    private fun flushTms() {
        var i = 0
        while (i < tmsBits.size) {
            val n = minOf(6, tmsBits.size - i)
            var b = 0
            for (k in 0 until n) b = b or (tmsBits[i + k] shl k)
            b = b or (tmsBits[i + n - 1] shl n)               // hold the last level
            put(0x4B, n - 1, b)
            i += n
        }
        tmsBits.clear()
    }

    private fun reset() {
        repeat(6) { tms(1) }
        flushTms()
        state = Tap.RESET
        goto(Tap.IDLE)
    }

    // the same paths as openFPGALoader's Jtag::set_state
    private fun goto(target: Tap) {
        while (state != target) {
            val (bit, next) = when (state) {
                Tap.RESET -> if (target == Tap.RESET) 1 to Tap.RESET else 0 to Tap.IDLE
                Tap.IDLE -> 1 to Tap.SEL_DR
                Tap.SEL_DR -> if (target in listOf(Tap.CAP_DR, Tap.SHIFT_DR, Tap.EXIT1_DR, Tap.PAUSE_DR, Tap.EXIT2_DR, Tap.UPD_DR))
                    0 to Tap.CAP_DR else 1 to Tap.SEL_IR
                Tap.SEL_IR -> if (target in listOf(Tap.CAP_IR, Tap.SHIFT_IR, Tap.EXIT1_IR, Tap.PAUSE_IR, Tap.EXIT2_IR, Tap.UPD_IR))
                    0 to Tap.CAP_IR else 1 to Tap.RESET
                Tap.CAP_DR -> if (target == Tap.SHIFT_DR) 0 to Tap.SHIFT_DR else 1 to Tap.EXIT1_DR
                Tap.SHIFT_DR -> 1 to Tap.EXIT1_DR
                Tap.EXIT1_DR -> if (target in listOf(Tap.PAUSE_DR, Tap.EXIT2_DR, Tap.SHIFT_DR)) 0 to Tap.PAUSE_DR else 1 to Tap.UPD_DR
                Tap.PAUSE_DR -> 1 to Tap.EXIT2_DR
                Tap.EXIT2_DR -> if (target in listOf(Tap.SHIFT_DR, Tap.EXIT1_DR, Tap.PAUSE_DR)) 0 to Tap.SHIFT_DR else 1 to Tap.UPD_DR
                Tap.UPD_DR, Tap.UPD_IR -> if (target == Tap.IDLE) 0 to Tap.IDLE else 1 to Tap.SEL_DR
                Tap.CAP_IR -> if (target == Tap.SHIFT_IR) 0 to Tap.SHIFT_IR else 1 to Tap.EXIT1_IR
                Tap.SHIFT_IR -> 1 to Tap.EXIT1_IR
                Tap.EXIT1_IR -> if (target in listOf(Tap.PAUSE_IR, Tap.EXIT2_IR, Tap.SHIFT_IR)) 0 to Tap.PAUSE_IR else 1 to Tap.UPD_IR
                Tap.PAUSE_IR -> 1 to Tap.EXIT2_IR
                Tap.EXIT2_IR -> if (target in listOf(Tap.SHIFT_IR, Tap.EXIT1_IR, Tap.PAUSE_IR)) 0 to Tap.SHIFT_IR else 1 to Tap.UPD_IR
                Tap.UNKNOWN -> throw IllegalStateException("TAP state unknown")
            }
            tms(bit); state = next
        }
        flushTms()
    }

    /** TMS-low clocks in the current (stable) state. */
    private fun clocks(n: Int) {
        var left = n
        while (left > 0) { val k = minOf(6, left); put(0x4B, k - 1, 0); left -= k }
    }

    /**
     * Shifts [bits] through IR or DR and ends in Run-Test/Idle. Returns the TDO bits (LSB first)
     * when [read], after the queue is flushed; otherwise the commands stay queued.
     */
    private fun shift(ir: Boolean, tdi: ByteArray?, bits: Int, read: Boolean): ByteArray? {
        goto(if (ir) Tap.SHIFT_IR else Tap.SHIFT_DR)
        val real = bits - 1                                  // the last bit goes out with TMS
        val nByte = real ushr 3
        val nBit = real and 7
        val wr = tdi != null
        val base = (if (wr) 0x10 else 0) or (if (read) 0x20 else 0) or 0x08 or (if (wr) 0x01 else 0)
        var off = 0
        var readBytes = 0
        while (off < nByte) {
            val n = minOf(nByte - off, 4096)
            put(base, (n - 1) and 0xFF, (n - 1) shr 8)
            if (wr) q.write(tdi!!, off, n)
            if (read) { expect += n; readBytes += n }
            off += n
        }
        if (nBit > 0) {
            put(base or 0x02, nBit - 1)
            if (wr) put(tdi!![nByte].toInt() and 0xFF)
            if (read) expect += 1
        }
        val lastBit = if (wr) (tdi!![nByte].toInt() ushr nBit) and 1 else 0
        put(0x4B or (if (read) 0x20 else 0), 0, if (lastBit == 1) 0x81 else 0x01)
        if (read) expect += 1
        state = if (ir) Tap.EXIT1_IR else Tap.EXIT1_DR
        goto(Tap.IDLE)
        if (!read) return null
        val r = flush()
        val out = ByteArray((bits + 7) / 8)
        System.arraycopy(r, 0, out, 0, nByte)
        var p = nByte
        if (nBit > 0) out[nByte] = ((r[p++].toInt() and 0xFF) ushr (8 - nBit)).toByte()
        val last = (r[p].toInt() and 0x80) ushr (7 - nBit)
        out[nByte] = (out[nByte].toInt() or last).toByte()
        return out
    }

    // ------------------------------------------------------------ Gowin
    private fun command(c: Int) { shift(true, byteArrayOf(c.toByte()), 8, false); clocks(6) }

    private fun reg32(c: Int): Int {
        command(c)
        val r = shift(false, byteArrayOf(-1, -1, -1, -1), 32, true)!!
        return (r[0].toInt() and 0xFF) or ((r[1].toInt() and 0xFF) shl 8) or
            ((r[2].toInt() and 0xFF) shl 16) or ((r[3].toInt() and 0xFF) shl 24)
    }

    fun idcode() = reg32(0x11)
    fun status() = reg32(0x41)

    private fun poll(mask: Int, value: Int, what: String) {
        val t0 = System.currentTimeMillis()
        while (status() and mask != value) {
            if (System.currentTimeMillis() - t0 > 5000) throw Exception("timeout: $what")
        }
    }

    private fun enableCfg() { command(0x15); poll(1 shl 7, 1 shl 7, "config enable") }
    private fun disableCfg() { command(0x3A); command(0x02); poll(1 shl 7, 0, "config disable") }

    // undocumented, needed after a failed configuration (openFPGALoader gw2a_force_state)
    private fun forceState() {
        if (status() and 1 == 0) return
        command(0x3A); command(0x00); idcode(); status()
        command(0x3A); command(0x00); status(); idcode()
        command(0x15); command(0x3C); command(0x02)
        command(0x3A); command(0x02); idcode(); command(0x02); idcode()
    }

    private fun eraseSram() {
        forceState()
        enableCfg()
        command(0x05); command(0x02)
        poll(1 shl 5, 1 shl 5, "SRAM erase")
        command(0x09); command(0x02)
        disableCfg()
        if (status() and (1 shl 13) != 0) throw Exception("SRAM erase failed")
    }

    /** Boots the bitstream in flash. */
    fun reload() { command(0x3C); command(0x02); flush() }

    // ------------------------------------------------------------ SPI flash through instruction 0x16
    private fun spi(tx: ByteArray, rxLen: Int = 0): ByteArray? {
        val len = tx.size + rxLen
        val n = if (rxLen > 0) len + 1 else len
        val j = ByteArray(n)
        for (i in tx.indices) j[i] = rev(tx[i].toInt()).toByte()
        command(0x16)
        goto(Tap.EXIT2_DR)
        val r = shift(false, j, 8 * n, rxLen > 0) ?: return null
        val out = ByteArray(rxLen)
        for (i in 0 until rxLen) {
            val k = tx.size + i
            out[i] = (rev((r[k].toInt() and 0xFF) ushr 1) or (r[k + 1].toInt() and 1)).toByte()
        }
        return out
    }

    private fun flashStatus(): Int {
        val tx = byteArrayOf(rev(0x05).toByte(), 0, 0)
        command(0x16)
        goto(Tap.EXIT2_DR)
        val r = shift(false, tx, 24, true)!!
        return rev((r[1].toInt() and 0xFF) ushr 1) or (r[2].toInt() and 1)
    }

    private fun waitReady(timeoutMs: Long) {
        val t0 = System.currentTimeMillis()
        while (flashStatus() and 1 != 0) if (System.currentTimeMillis() - t0 > timeoutMs) throw Exception("flash busy timeout")
    }

    private fun wren() { spi(byteArrayOf(0x06)) }
    private fun a24(c: Int, a: Int) = byteArrayOf(c.toByte(), (a shr 16).toByte(), (a shr 8).toByte(), a.toByte())

    fun flashId(): Int {
        val r = spi(byteArrayOf(0x9F.toByte()), 3)!!
        return ((r[0].toInt() and 0xFF) shl 16) or ((r[1].toInt() and 0xFF) shl 8) or (r[2].toInt() and 0xFF)
    }

    /** Puts the FPGA into flash-access mode; returns the JEDEC ID of the flash. */
    fun beginFlash(): Int {
        val id = idcode()
        if (id != GW2AR18_IDCODE) throw Exception("not a Tang Nano 20K (IDCODE %08x)".format(id))
        eraseSram()
        spi(byteArrayOf(0x66)); spi(byteArrayOf(0x99.toByte()))      // flash reset
        flush()
        Thread.sleep(1)
        val jedec = flashId()
        if (jedec == 0 || jedec == 0xFFFFFF) throw Exception("no SPI flash answers")
        if (flashStatus() and 0x1C != 0) {                       // block protection set: clear it
            wren(); spi(byteArrayOf(0x01, 0x00)); waitReady(1000)
        }
        return jedec
    }

    /** Erases 64 KB blocks and programs [data] at [addr] (64 KB aligned), then verifies it. */
    fun writeFlash(addr: Int, data: ByteArray, progress: (String, Float) -> Unit) {
        require(addr and 0xFFFF == 0)
        val blocks = (data.size + 0xFFFF) / 0x10000
        for (b in 0 until blocks) {
            progress("Erasing", b.toFloat() / blocks)
            wren(); spi(a24(0xD8, addr + b * 0x10000)); waitReady(3000)
        }
        var o = 0
        while (o < data.size) {
            val n = minOf(256, data.size - o)
            wren()
            spi(a24(0x02, addr + o) + data.copyOfRange(o, o + n))
            waitReady(100)
            o += n
            if ((o and 0x3FFF) == 0 || o >= data.size) progress("Writing", o.toFloat() / data.size)
        }
        o = 0
        while (o < data.size) {
            val n = minOf(1024, data.size - o)
            val r = spi(a24(0x03, addr + o), n)!!
            for (i in 0 until n) if (r[i] != data[o + i]) throw Exception("verify failed at 0x%06x".format(addr + o + i))
            o += n
            if ((o and 0x3FFF) == 0 || o >= data.size) progress("Verifying", o.toFloat() / data.size)
        }
    }
}

/** A Gowin .fs bitstream (text, one character per bit) as the bytes the flash holds. */
fun fsToBin(text: String): ByteArray {
    val out = ByteArrayOutputStream()
    var acc = 0; var n = 0
    for (line in text.lineSequence()) {
        if (line.isEmpty() || line.startsWith("//")) continue
        for (ch in line) {
            if (ch != '0' && ch != '1') continue
            acc = (acc shl 1) or (ch - '0')
            if (++n == 8) { out.write(acc); acc = 0; n = 0 }
        }
    }
    if (n > 0) out.write(acc shl (8 - n))
    return out.toByteArray()
}
