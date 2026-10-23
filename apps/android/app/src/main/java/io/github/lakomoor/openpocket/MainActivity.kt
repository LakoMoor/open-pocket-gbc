package io.github.lakomoor.openpocket

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.horizontalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.FilterQuality
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

// after Analogue's design language: black canvas, white type, greys, no brand colour
private val Bg = Color(0xFF000000)
private val Panel = Color(0xFF1C1C1C)
private val Panel2 = Color(0xFF1C1C1C)
private val Line = Color(0xFF2A2A2A)
private val Text = Color(0xFFFFFFFF)
private val Dim = Color(0xFF7A7A7A)
private val Accent = Color(0xFFFFFFFF)
private val Ok = Color(0xFFEDEDED)
private val PillC = Color(0xFFFFFFFF)

class MainActivity : ComponentActivity() {
    private val usbReceiver = object : BroadcastReceiver() {
        override fun onReceive(c: Context, i: Intent) { Board.connect(c) }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val f = IntentFilter("io.github.lakomoor.openpocket.USB_PERMISSION").apply {
            addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
        }
        if (Build.VERSION.SDK_INT >= 33) registerReceiver(usbReceiver, f, RECEIVER_NOT_EXPORTED) else registerReceiver(usbReceiver, f)
        Board.connect(this)
        setContent { App() }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Board.connect(this)                         // USB device attached
    }

    override fun onDestroy() {
        unregisterReceiver(usbReceiver)
        super.onDestroy()
    }
}

@Composable
fun App() {
    var tab by remember { mutableStateOf(0) }
    val state by Board.state.collectAsState()
    val ctx = LocalContext.current
    MaterialTheme(colorScheme = darkColorScheme(background = Bg, surface = Panel, primary = Accent)) {
        Column(Modifier.fillMaxSize().background(Bg).systemBarsPadding()) {
            Row(Modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 14.dp), verticalAlignment = Alignment.CenterVertically) {
                Text("Open Pocket", color = Text, fontWeight = FontWeight.Medium, fontSize = 17.sp, letterSpacing = (-0.5).sp)
                Spacer(Modifier.width(10.dp))
                Spacer(Modifier.weight(1f))
                Row(Modifier.clip(RoundedCornerShape(50)).background(Panel2).clickable { Board.connect(ctx) }
                    .padding(horizontal = 12.dp, vertical = 6.dp), verticalAlignment = Alignment.CenterVertically) {
                    Box(Modifier.size(9.dp).clip(CircleShape).background(if (state == Board.State.Connected) Ok else Color(0xFF555555)))
                    Spacer(Modifier.width(8.dp))
                    Text(when (state) {
                        Board.State.Connected -> "connected"
                        Board.State.NeedsPermission -> "allow USB access"
                        Board.State.Error -> "USB error, tap to retry"
                        else -> "plug in the board (OTG)"
                    }, color = Dim, fontSize = 13.sp)
                }
            }
            Box(Modifier.weight(1f)) {
                when (tab) {
                    0 -> RemoteScreen()
                    1 -> IdeScreen()
                    2 -> UpdateScreen()
                    else -> LogScreen()
                }
            }
            Row(Modifier.fillMaxWidth().padding(12.dp), horizontalArrangement = Arrangement.SpaceEvenly) {
                listOf("Remote", "IDE", "Update", "Log").forEachIndexed { i, t ->
                    Text(t, color = if (tab == i) Color(0xFF111111) else Dim, fontWeight = if (tab == i) FontWeight.SemiBold else FontWeight.Normal,
                        modifier = Modifier.clip(RoundedCornerShape(50)).background(if (tab == i) PillC else Color.Transparent)
                            .clickable { tab = i }.padding(horizontal = 16.dp, vertical = 9.dp))
                }
            }
        }
    }
}

// ---------------------------------------------------------------- menu pictures
private val PAL = intArrayOf(0x101010, 0x000000, 0x0F380F, 0x242424, 0x3C3C3C, 0x7A7A7A, 0xBEBEBE, 0xFFFFFF,
    0x3A6FF0, 0x9BBC0F, 0xF5C518, 0xE5483C, 0x306230, 0x0E1A33, 0x8BAC0F, 0x000000)

private fun renderCells(font: IntArray, rows: List<String>, cols: Int, w: Int, h: Int, top: Int): ImageBitmap {
    val px = IntArray(w * h) { 0xFF000000.toInt() }
    for (cy in rows.indices) for (cx in 0 until cols) {
        val v = rows[cy].substring(cx * 4, cx * 4 + 4).toInt(16)
        val attr = v shr 8; val ch = v and 0xFF
        val fg = PAL[attr and 15]; val bg = PAL[attr shr 4]
        val code = ch and 0x7F; val ext = ch and 0x80 != 0
        for (py in 0 until 10) {
            val fy = py - 1
            val bits = if (fy < 0 || fy > 7) (if (ext) font[code * 8 + (if (fy < 0) 0 else 7)] else 0) else font[code * 8 + fy]
            for (pxx in 0 until 8) {
                val y = top + cy * 10 + py
                if (y < h) px[y * w + cx * 8 + pxx] = (0xFF shl 24) or (if ((bits shr (7 - pxx)) and 1 == 1) fg else bg)
            }
        }
    }
    return Bitmap.createBitmap(px, w, h, Bitmap.Config.ARGB_8888).asImageBitmap()
}

@Composable
fun RemoteScreen() {
    val ctx = LocalContext.current
    val scope = rememberCoroutineScope()
    val font = remember { ctx.assets.open("font8x8.hex").bufferedReader().readLines().filter { it.isNotBlank() }.map { it.trim().toInt(16) }.toIntArray() }
    var lcd by remember { mutableStateOf<ImageBitmap?>(null) }
    var osd by remember { mutableStateOf<ImageBitmap?>(null) }
    var auto by remember { mutableStateOf(false) }
    var note by remember { mutableStateOf("") }
    suspend fun shot() {
        val r = withContext(Dispatchers.IO) { Board.menuShot() }
        if (r == null) { note = "No menu open: press MENU first"; return }
        note = ""
        lcd = renderCells(font, r.first, 16, 128, 128, 4)
        osd = renderCells(font, r.second, 42, 336, 240, 0)
    }
    // live: the firmware streams the real picture (game and menu) at ~2 Mbaud
    val live by Board.live.collectAsState()
    val tick by LiveScreen.frame.collectAsState()
    val hdmiBmp = remember { Bitmap.createBitmap(720, 480, Bitmap.Config.ARGB_8888) }
    val lcdBmp = remember { Bitmap.createBitmap(128, 128, Bitmap.Config.ARGB_8888) }
    var liveHdmi by remember { mutableStateOf<ImageBitmap?>(null) }
    var liveLcd by remember { mutableStateOf<ImageBitmap?>(null) }
    LaunchedEffect(Unit) { LiveScreen.font = font }
    LaunchedEffect(auto) {
        if (!auto) { Board.stopScreen(); note = ""; return@LaunchedEffect }
        Board.startScreen()
        note = "Asking the board for the live picture…"
        delay(4000)
        if (!Board.streaming) note = "The board did not answer: the live picture needs bitstream 1.3 and firmware 1.3 or newer (1.4 is faster). Install both: Update › Install over USB, or SD card › System Update."
    }
    LaunchedEffect(tick) {
        if (!live) return@LaunchedEffect
        LiveScreen.renderHdmi(hdmiBmp); LiveScreen.renderLcd(lcdBmp)
        liveHdmi = hdmiBmp.asImageBitmap(); liveLcd = lcdBmp.asImageBitmap()
        note = "live · %.0f fps".format(LiveScreen.fps)
    }
    DisposableEffect(Unit) { onDispose { Board.stopScreen() } }
    Column(Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(horizontal = 18.dp)) {
        if (live && liveHdmi != null) {
            Screen(liveHdmi, Modifier.fillMaxWidth().aspectRatio(720f / 480f), tick)
            Spacer(Modifier.height(8.dp))
            Screen(liveLcd, Modifier.width(128.dp).aspectRatio(1f), tick)
        } else Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Screen(lcd, Modifier.weight(0.42f).aspectRatio(1f))
            Screen(osd, Modifier.weight(0.58f).aspectRatio(336f / 240f))
        }
        Row(Modifier.padding(vertical = 10.dp), verticalAlignment = Alignment.CenterVertically) {
            Pill("Show the menu") { scope.launch { shot() } }
            Spacer(Modifier.width(12.dp))
            Switch(checked = auto, onCheckedChange = { auto = it })
            Spacer(Modifier.width(6.dp))
            Text("live", color = Dim, fontSize = 13.sp)
            if (live && liveHdmi != null) {
                Spacer(Modifier.width(12.dp))
                Pill("Screenshot") {
                    note = try { "Saved to Pictures/OpenPocket: " + LiveScreen.saveShot(ctx) + ".png" } catch (e: Exception) { "Screenshot: ${e.message}" }
                }
            }
        }
        if (note.isNotEmpty()) Text(note, color = Dim, fontSize = 13.sp)
        Spacer(Modifier.height(18.dp))
        // the pad
        Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Key('U', "▲", Modifier.size(58.dp))
                Row { Key('L', "◀", Modifier.size(58.dp)); Box(Modifier.size(58.dp).padding(3.dp).background(Panel2, RoundedCornerShape(6.dp))); Key('R', "▶", Modifier.size(58.dp)) }
                Key('D', "▼", Modifier.size(58.dp))
            }
            Spacer(Modifier.weight(1f))
            Row(Modifier.rotate(-18f), horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                Key('B', "B", Modifier.size(70.dp), round = true)
                Key('A', "A", Modifier.size(70.dp).offset(y = (-14).dp), round = true)
            }
        }
        Spacer(Modifier.height(22.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Center) {
            Key('S', "SELECT", Modifier.height(40.dp).width(92.dp), pill = true)
            Spacer(Modifier.width(10.dp))
            Key('M', "MENU", Modifier.height(40.dp).width(80.dp), pill = true)
            Spacer(Modifier.width(10.dp))
            Key('T', "START", Modifier.height(40.dp).width(92.dp), pill = true)
        }
        Spacer(Modifier.height(12.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Center) {
            Key('X', "RESET GAME", Modifier.height(36.dp).width(130.dp), pill = true)
        }
        Spacer(Modifier.height(20.dp))
    }
}

@Composable
private fun Screen(img: ImageBitmap?, mod: Modifier, tick: Int = 0) {
    Box(mod.clip(RoundedCornerShape(12.dp)).background(Color.Black).border(1.dp, Line, RoundedCornerShape(12.dp)), contentAlignment = Alignment.Center) {
        // the bitmap is reused between frames: `tick` makes Compose redraw it
        if (img != null) key(tick) { Image(img, null, Modifier.fillMaxSize(), filterQuality = FilterQuality.None) }
    }
}

@Composable
private fun Key(k: Char, label: String, mod: Modifier, round: Boolean = false, pill: Boolean = false, color: Color = Text) {
    var down by remember { mutableStateOf(false) }
    val shape = if (round || pill) RoundedCornerShape(50) else RoundedCornerShape(10.dp)
    Box(mod.padding(3.dp).clip(shape).background(if (down) PillC else Panel2).border(1.dp, Line, shape)
        .pointerInput(k) {
            detectTapGestures(onPress = {
                down = true; Board.press(k, true)
                tryAwaitRelease()
                down = false; Board.press(k, false)
            })
        }, contentAlignment = Alignment.Center) {
        Text(label, color = if (down) Color(0xFF111111) else color, fontWeight = FontWeight.Bold, fontSize = if (pill) 12.sp else 18.sp)
    }
}

@Composable
private fun Pill(text: String, primary: Boolean = false, enabled: Boolean = true, onClick: () -> Unit) {
    Box(Modifier.clip(RoundedCornerShape(50)).background(if (primary) Accent else Color.Transparent)
        .border(1.dp, if (primary) Accent else Line, RoundedCornerShape(50))
        .clickable(enabled = enabled, onClick = onClick).padding(horizontal = 18.dp, vertical = 11.dp)) {
        Text(text, color = if (!enabled) Dim else if (primary) Color.Black else Text, fontWeight = if (primary) FontWeight.Medium else FontWeight.Normal, letterSpacing = (-0.3).sp)
    }
}

// ---------------------------------------------------------------- update
@Composable
fun UpdateScreen() {
    val ctx = LocalContext.current
    val scope = rememberCoroutineScope()
    var info by remember { mutableStateOf<Release.Info?>(null) }
    var error by remember { mutableStateOf("") }
    var progress by remember { mutableStateOf<Pair<String, Float>?>(null) }
    var result by remember { mutableStateOf("") }
    LaunchedEffect(Unit) {
        try { info = withContext(Dispatchers.IO) { Release.latest() } } catch (e: Exception) { error = e.message ?: "error" }
    }
    val pick = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
        val i = info ?: return@rememberLauncherForActivityResult
        if (uri == null) return@rememberLauncherForActivityResult
        scope.launch {
            result = ""
            try {
                val done = withContext(Dispatchers.IO) { Release.saveTo(ctx, uri, i) { n, p -> progress = n to p } }
                result = "Saved ${done.joinToString(" and ")}. Put the card in the board: Menu › System › System Update."
            } catch (e: Exception) { result = "Failed: ${e.message}" }
            progress = null
        }
    }
    Column(Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(horizontal = 20.dp)) {
        Text("Update", color = Text, fontSize = 44.sp, fontWeight = FontWeight.Medium, letterSpacing = (-2).sp)
        Text("Downloads the latest release and writes it to an SD card. The board installs it from the card: Menu › System › System Update.",
            color = Dim, fontSize = 14.sp, modifier = Modifier.padding(top = 4.dp, bottom = 18.dp))
        Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = Panel), shape = RoundedCornerShape(16.dp)) {
            Column(Modifier.padding(18.dp)) {
                when {
                    info != null -> {
                        val i = info!!
                        Text(i.name.ifEmpty { i.tag }, color = Text, fontWeight = FontWeight.SemiBold, fontSize = 17.sp)
                        Text("${i.tag} · ${i.date}", color = Dim, fontSize = 13.sp)
                        Spacer(Modifier.height(10.dp))
                        for (a in i.assets) Row(Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
                            Text(a.name, color = Text, fontFamily = FontFamily.Monospace, fontSize = 13.sp)
                            Spacer(Modifier.weight(1f))
                            Text("${a.size / 1024} KB", color = Dim, fontSize = 13.sp)
                        }
                    }
                    error.isNotEmpty() -> Text(error, color = Dim)
                    else -> Text("Checking GitHub…", color = Dim)
                }
            }
        }
        Spacer(Modifier.height(16.dp))
        Pill("Choose the SD card and save", primary = true, enabled = info?.assets?.isNotEmpty() == true && progress == null) { pick.launch(null) }
        progress?.let { (n, p) ->
            Spacer(Modifier.height(16.dp))
            Text("$n  ${(p * 100).toInt()}%", color = Dim, fontSize = 13.sp)
            Spacer(Modifier.height(6.dp))
            LinearProgressIndicator(progress = { p }, modifier = Modifier.fillMaxWidth().height(6.dp).clip(RoundedCornerShape(50)), color = Color.White, trackColor = Panel2)
        }
        if (result.isNotEmpty()) {
            Spacer(Modifier.height(14.dp))
            Text(result, color = if (result.startsWith("Failed")) Color(0xFFFF8A80) else Ok)
        }
        Spacer(Modifier.height(30.dp))
        FlashCard(info)
        Spacer(Modifier.height(24.dp))
        Text("Pick the root of the card (phone SD slot or a USB card reader).\nFirmware restarts the menu; after a bitstream update switch the board off and on.",
            color = Dim, fontSize = 13.sp)
    }
}

// ---------------------------------------------------------------- log
@Composable
fun LogScreen() {
    val log by Board.log.collectAsState()
    val scroll = rememberScrollState()
    LaunchedEffect(log) { scroll.scrollTo(scroll.maxValue) }
    Column(Modifier.fillMaxSize().padding(horizontal = 16.dp)) {
        Text(log.ifEmpty { "The firmware log appears here." }, color = Color(0xFFB9C0D4), fontFamily = FontFamily.Monospace, fontSize = 11.sp,
            modifier = Modifier.fillMaxSize().clip(RoundedCornerShape(14.dp)).background(Color(0xFF07080C)).verticalScroll(scroll).padding(12.dp))
    }
}

// ---------------------------------------------------------------- install over USB (JTAG)
@Composable
fun FlashCard(info: Release.Info?) {
    val ctx = LocalContext.current
    val scope = rememberCoroutineScope()
    var progress by remember { mutableStateOf<Pair<String, Float>?>(null) }
    var result by remember { mutableStateOf("") }
    fun go(load: suspend () -> List<FlashPart>) {
        scope.launch {
            result = ""
            try {
                val parts = load()
                result = withContext(Dispatchers.IO) { Flasher.run(ctx, parts) { n, p -> progress = n to p } }
            } catch (e: Exception) { result = "Failed: ${e.message}" }
            progress = null
        }
    }
    val pick = rememberLauncherForActivityResult(ActivityResultContracts.OpenMultipleDocuments()) { uris ->
        if (uris.isNotEmpty()) go { withContext(Dispatchers.IO) { Flasher.parts(ctx, uris) } }
    }
    Text("Install over USB", color = Text, fontSize = 28.sp, fontWeight = FontWeight.Medium, letterSpacing = (-1).sp)
    Text("Writes the bitstream and the firmware straight into the board's flash over JTAG, like openFPGALoader on a PC. Works on a board that does not boot.",
        color = Dim, fontSize = 14.sp, modifier = Modifier.padding(top = 4.dp, bottom = 14.dp))
    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
        Pill("Install the latest release", primary = true, enabled = info?.assets?.isNotEmpty() == true && progress == null) {
            val i = info ?: return@Pill
            go {
                withContext(Dispatchers.IO) {
                    i.assets.map { a ->
                        val f = java.io.File(ctx.cacheDir, "release/${i.tag}/${a.name}")
                        Release.download(a, f) { p -> progress = "Download ${a.name}" to p }   // always fresh: a release can be updated
                        val addr = if ("fpga" in a.name) Flasher.BITSTREAM else Flasher.FIRMWARE
                        FlashPart(a.name, addr, f.readBytes())
                    }.sortedBy { it.addr }
                }
            }
        }
        Pill("Choose files", enabled = progress == null) { pick.launch(arrayOf("*/*")) }
    }
    progress?.let { (n, p) ->
        Spacer(Modifier.height(14.dp))
        Text("$n  ${(p * 100).toInt()}%", color = Dim, fontSize = 13.sp)
        Spacer(Modifier.height(6.dp))
        LinearProgressIndicator(progress = { p }, modifier = Modifier.fillMaxWidth().height(6.dp).clip(RoundedCornerShape(50)), color = Color.White, trackColor = Panel2)
    }
    if (result.isNotEmpty()) {
        Spacer(Modifier.height(12.dp))
        Text(result, color = if (result.startsWith("Failed")) Color(0xFFFF8A80) else Ok)
    }
    Spacer(Modifier.height(8.dp))
    Text("Files: gbc_top.fs or opgbc_fpga.bin (bitstream, 0x000000), fw.bin or opgbc_fw.bin (firmware, 0x100000), games.bin (0x200000). Keep the board plugged in until it restarts.",
        color = Dim, fontSize = 12.sp)
}

// ---------------------------------------------------------------- IDE
@Composable
fun IdeScreen() {
    val ctx = LocalContext.current
    val scope = rememberCoroutineScope()
    var note by remember { mutableStateOf("") }
    var busy by remember { mutableStateOf(false) }
    val web = remember { ideWebView(ctx) }
    fun reload() { web.evaluateJavascript("window.ideReload && ideReload()", null) }
    val folder = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
        if (uri != null) { Sources.useTree(ctx, uri); reload(); note = "" }
    }
    val fwFile = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
        if (uri != null) scope.launch {
            withContext(Dispatchers.IO) {
                val f = Sources.fwBin(ctx); f.parentFile?.mkdirs()
                ctx.contentResolver.openInputStream(uri)!!.use { i -> f.outputStream().use { i.copyTo(it) } }
            }
            note = "fw.bin loaded: press Run in the Simulator"
        }
    }
    Column(Modifier.fillMaxSize()) {
        Row(Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()).padding(horizontal = 12.dp, vertical = 4.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Pill("Get sources", enabled = !busy) {
                busy = true
                scope.launch {
                    note = try { withContext(Dispatchers.IO) { Sources.download(ctx) { n -> note = "Downloading: $n" } }; reload(); "Sources from GitHub (main)" }
                    catch (e: Exception) { "Failed: ${e.message}" }
                    busy = false
                }
            }
            Pill("Open folder") { folder.launch(null) }
            Pill("fw.bin: release", enabled = !busy) {
                busy = true
                scope.launch {
                    note = try {
                        withContext(Dispatchers.IO) {
                            val i = Release.latest()
                            val a = i.assets.firstOrNull { it.name == "opgbc_fw.bin" } ?: throw Exception("the release has no firmware")
                            Release.download(a, Sources.fwBin(ctx)) { p -> note = "Downloading fw.bin ${(p * 100).toInt()}%" }
                            "fw.bin from ${i.tag}: press Run in the Simulator"
                        }
                    } catch (e: Exception) { "Failed: ${e.message}" }
                    busy = false
                }
            }
            Pill("fw.bin: file") { fwFile.launch(arrayOf("*/*")) }
        }
        if (note.isNotEmpty()) Text(note, color = Dim, fontSize = 12.sp, modifier = Modifier.padding(horizontal = 16.dp))
        AndroidView(factory = { web }, modifier = Modifier.fillMaxWidth().weight(1f))
    }
}
