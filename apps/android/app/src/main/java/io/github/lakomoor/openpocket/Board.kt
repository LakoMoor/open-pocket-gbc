package io.github.lakomoor.openpocket

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbManager
import android.os.Build
import com.hoho.android.usbserial.driver.UsbSerialPort
import com.hoho.android.usbserial.driver.UsbSerialProber
import com.hoho.android.usbserial.util.SerialInputOutputManager
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.util.concurrent.Executors

/**
 * The board over USB OTG: the Tang Nano 20K debugger is an FT2232-compatible chip; its second
 * port is the FPGA's UART (115200 8N1). One character per button event (upper case = press),
 * and Select in the menu makes the firmware print the LCD and HDMI menu text buffers.
 */
object Board : SerialInputOutputManager.Listener {
    const val VID = 0x0403
    const val PID = 0x6010
    private const val ACTION_PERMISSION = "io.github.lakomoor.openpocket.USB_PERMISSION"

    enum class State { NoDevice, NeedsPermission, Connected, Error }

    private val _state = MutableStateFlow(State.NoDevice)
    val state = _state.asStateFlow()
    private val _log = MutableStateFlow("")
    val log = _log.asStateFlow()

    private var port: UsbSerialPort? = null
    private var io: SerialInputOutputManager? = null
    private val rx = StringBuilder()
    @Volatile private var dump: ((String) -> Unit)? = null
    private val writer = Executors.newSingleThreadExecutor()

    fun connect(ctx: Context): State {
        if (port != null) return State.Connected.also { _state.value = it }
        val mgr = ctx.getSystemService(Context.USB_SERVICE) as UsbManager
        val driver = UsbSerialProber.getDefaultProber().findAllDrivers(mgr)
            .firstOrNull { it.device.vendorId == VID && it.device.productId == PID }
            ?: return State.NoDevice.also { _state.value = it }
        if (!mgr.hasPermission(driver.device)) {
            val flags = if (Build.VERSION.SDK_INT >= 31) PendingIntent.FLAG_MUTABLE else 0
            val pi = PendingIntent.getBroadcast(ctx, 0, Intent(ACTION_PERMISSION).setPackage(ctx.packageName), flags)
            mgr.requestPermission(driver.device, pi)
            return State.NeedsPermission.also { _state.value = it }
        }
        return try {
            val conn = mgr.openDevice(driver.device)
            val p = driver.ports.getOrElse(1) { driver.ports[0] }      // port B is the UART
            p.open(conn)
            p.setParameters(115200, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE)
            port = p
            io = SerialInputOutputManager(p, this).also { it.start() }
            appendLog("connected\n")
            State.Connected
        } catch (e: Exception) {
            appendLog("USB: ${e.message}\n")
            State.Error
        }.also { _state.value = it }
    }

    fun disconnect() {
        _live.value = false; fast = false; keepalive?.interrupt(); keepalive = null
        io?.stop(); io = null
        try { port?.close() } catch (_: Exception) {}
        port = null
        _state.value = State.NoDevice
    }

    private fun write(s: String) {
        val p = port ?: return
        writer.execute { try { p.write(s.toByteArray(), 200) } catch (e: Exception) { appendLog("USB: ${e.message}\n"); disconnect() } }
    }

    fun press(k: Char, down: Boolean) = write(if (down) k.uppercase() else k.lowercase())
    fun tap(k: Char) { write(k.uppercase()); writer.execute { Thread.sleep(100) }; write(k.lowercase()) }

    /** LCD (12 rows of 16 cells) and HDMI (24 rows of 42) as hex rows, or null when no menu is open. */
    fun menuShot(): Pair<List<String>, List<String>>? {
        if (port == null) return null
        val lock = Object()
        var text: String? = null
        synchronized(rx) { rx.setLength(0) }
        dump = { t -> synchronized(lock) { text = t; lock.notifyAll() } }
        tap('S')
        synchronized(lock) { if (text == null) lock.wait(2500) }
        dump = null
        val t = text ?: return null
        if (!t.contains("LCD-BEGIN")) return null
        fun grab(a: String, b: String, w: Int) = t.substringAfter(a).substringBefore(b)
            .split('\n').map { it.trim() }.filter { it.length == w * 4 }
        return grab("LCD-BEGIN", "LCD-END", 16) to grab("OSD-BEGIN", "OSD-END", 42)
    }

    // ---- live screen: 'W' asks the firmware to switch to ~2 Mbaud and stream (see LiveScreen); rows
    // come as 'R' (word PackBits without a length). Firmware 1.3 knows only 'V' and 'G' rows.
    private val _live = MutableStateFlow(false)
    val live = _live.asStateFlow()
    @Volatile private var fast = false
    val streaming get() = fast             // the firmware answered "#SCR" and the port runs at 2 Mbaud
    private var keepalive: Thread? = null

    fun startScreen() {
        if (port == null || _live.value) return
        _live.value = true
        write("W")
        keepalive = Thread {
            // the firmware keeps only the last byte it received: until it answers, send nothing but
            // 'W' (after ~2 s also 'V' for firmware 1.3)
            var ask = 0
            while (_live.value && port != null) {
                try { Thread.sleep(if (fast) 500L else 300L) } catch (_: InterruptedException) { break }
                write(if (fast) "." else if (++ask > 6 && ask % 2 == 1) "V" else "W")
            }
        }.also { it.isDaemon = true; it.start() }
    }

    fun stopScreen() {
        if (!_live.value) return
        _live.value = false
        keepalive?.interrupt(); keepalive = null
        write("v")
        writer.execute {
            // back to 115200 only once the stream is quiet: data at 2 Mbaud into a port at 115200
            // can hang the BL616 (the firmware finishes the frame it is sending)
            val t0 = System.currentTimeMillis()
            Thread.sleep(60)
            while (System.currentTimeMillis() - lastRx < 150 && System.currentTimeMillis() - t0 < 2000) Thread.sleep(30)
            try { port?.setParameters(115200, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE) } catch (_: Exception) {}
            fast = false
        }
    }

    private fun goFast(baud: Int) {
        writer.execute {
            try {
                port?.setParameters(baud, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE)
                pState = 0
                port?.write(".".toByteArray(), 200)       // the firmware starts sending once a byte arrives at the new rate
                fast = true
                appendLog("screen stream at $baud baud\n")
            } catch (e: Exception) { appendLog("USB: can't set $baud baud: ${e.message}\n"); _live.value = false }
        }
    }

    // packet parser: text until 0x00, then type, u16 length, payload
    private var pState = 0; private var pType = ' '; private var pLen = 0; private var pPos = 0
    private val pBuf = ByteArray(4096)
    private val text = java.io.ByteArrayOutputStream()

    private var rY = 0; private var rN = 0; private var rC = 0; private var rK = 0; private var rX = 0
    private val rW = IntArray(80)
    private fun rowToG() {
        val g = ByteArray(323)
        g[0] = rY.toByte(); g[1] = 127; g[258] = 31
        for (i in 0 until 80) {
            val o = (if (i < 64) 2 else 3) + i * 4; val w = rW[i]
            g[o] = w.toByte(); g[o + 1] = (w shr 8).toByte(); g[o + 2] = (w shr 16).toByte(); g[o + 3] = (w ushr 24).toByte()
        }
        LiveScreen.packet('G', g, g.size)
    }

    @Volatile private var lastRx = 0L
    override fun onNewData(data: ByteArray) {
        lastRx = System.currentTimeMillis()
        if (!fast) { onText(data); return }
        for (b in data) {
            val v = b.toInt() and 255
            when (pState) {
                0 -> if (v == 0) pState = 1 else text.write(v)
                1 -> { pType = v.toChar(); pState = if (pType == 'R') 6 else 2 }
                2 -> { pLen = v; pState = 3 }
                3 -> { pLen = pLen or (v shl 8); pPos = 0; pState = if (pLen == 0) { LiveScreen.packet(pType, pBuf, 0); 0 } else if (pLen > pBuf.size) 5 else 4 }
                4 -> { pBuf[pPos++] = b; if (pPos == pLen) { LiveScreen.packet(pType, pBuf, pLen); pState = 0 } }
                5 -> if (++pPos == pLen) pState = 0                // oversized: skip
                // 'R': y, then PackBits over the row's 80 words (c < 128: c + 1 literal words, else
                // c - 126 copies of one word); handed on as a 'G' row of two literal runs
                6 -> { rY = v; rN = 0; pState = 7 }
                7 -> { rC = v; rK = 0; rX = 0; pState = 8 }
                8 -> {
                    rX = rX or (v shl (8 * rK++))
                    if (rK == 4) {
                        rK = 0
                        if (rC < 128) { if (rN < 80) rW[rN++] = rX; rX = 0; if (rC-- == 0) pState = 7 }
                        else { var r = rC - 126; while (r-- > 0 && rN < 80) rW[rN++] = rX; pState = 7 }
                        if (pState == 7 && rN >= 80) { rowToG(); pState = 0 }
                    }
                }
            }
        }
        if (text.size() > 0) { onText(text.toByteArray()); text.reset() }
    }

    private fun onText(data: ByteArray) {
        val s = String(data, Charsets.ISO_8859_1)
        synchronized(rx) {
            rx.append(s)
            val d = dump
            if (d != null) {
                if (rx.contains("OSD-END")) { val t = rx.toString(); rx.setLength(0); d(t) }
                return
            }
            val i = rx.lastIndexOf("\n")
            if (i < 0) return
            val text = rx.substring(0, i + 1)
            rx.delete(0, i + 1)
            val lines = text.split('\n').map { it.trimEnd('\r') }
            // the firmware switched to the stream rate (1.985 Mbaud): 2 Mbaud is within 1 %
            if (_live.value && !fast && lines.any { it.startsWith("#SCR ") }) goFast(2_000_000)
            val keep = lines.filter { l ->
                l.isNotEmpty() && !l.startsWith("LCD-") && !l.startsWith("OSD-") &&
                    !((l.length == 64 || l.length == 84) && l.all { it in "0123456789abcdef" })
            }
            if (keep.isNotEmpty()) appendLog(keep.joinToString("\n") + "\n")
        }
    }

    override fun onRunError(e: Exception) {
        appendLog("USB: ${e.message}\n")
        disconnect()
    }

    fun appendLog(s: String) {
        val t = _log.value + s
        _log.value = if (t.length > 40000) t.takeLast(30000) else t
    }
}
