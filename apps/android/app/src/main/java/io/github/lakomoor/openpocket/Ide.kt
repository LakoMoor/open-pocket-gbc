package io.github.lakomoor.openpocket

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.webkit.JavascriptInterface
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.documentfile.provider.DocumentFile
import androidx.webkit.WebViewAssetLoader
import org.json.JSONArray
import java.io.File
import java.io.FileInputStream
import java.net.HttpURLConnection
import java.net.URL
import java.util.zip.ZipInputStream

/**
 * Where the IDE's sources live: a copy inside the app (downloaded from GitHub) or a folder on the
 * phone picked with the system file picker (a checkout synced with a PC, for example). Only the
 * firmware tree (fw/) and the docs are listed; builds happen on a PC.
 */
object Sources {
    private const val PREFS = "ide"
    private val EXT = Regex(""".*\.(c|h|S|s|asm|inc|ld|py|sh|md|txt)$""")

    fun internalDir(ctx: Context) = File(ctx.filesDir, "src")
    fun fwBin(ctx: Context) = File(ctx.filesDir, "ide/fw.bin")

    fun tree(ctx: Context): Uri? =
        ctx.getSharedPreferences(PREFS, 0).getString("tree", null)?.let(Uri::parse)

    fun useTree(ctx: Context, uri: Uri?) {
        if (uri != null) ctx.contentResolver.takePersistableUriPermission(uri,
            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        ctx.getSharedPreferences(PREFS, 0).edit().putString("tree", uri?.toString()).apply()
    }

    fun describe(ctx: Context): String = tree(ctx)?.let { "folder: " + (DocumentFile.fromTreeUri(ctx, it)?.name ?: it.toString()) }
        ?: "the app's copy of the GitHub sources"

    // ---- listing / reading / writing, paths relative to the repository root
    fun list(ctx: Context): List<String> {
        val out = mutableListOf<String>()
        val t = tree(ctx)
        if (t != null) {
            val root = DocumentFile.fromTreeUri(ctx, t) ?: return out
            fun walk(d: DocumentFile, prefix: String, depth: Int) {
                if (depth > 6) return
                for (f in d.listFiles()) {
                    val name = f.name ?: continue
                    if (name.startsWith(".") || name == "build" || name == "node_modules") continue
                    if (f.isDirectory) walk(f, "$prefix$name/", depth + 1)
                    else if (EXT.matches(name)) out += "$prefix$name"
                }
            }
            // a repository root or the fw folder itself
            val fw = root.findFile("fw")
            if (fw != null && fw.isDirectory) walk(fw, "fw/", 0) else walk(root, "fw/", 0)
        } else {
            val base = internalDir(ctx)
            base.walkTopDown().filter { it.isFile && EXT.matches(it.name) && "/build/" !in it.path.replace('\\', '/') }
                .forEach { out += it.relativeTo(base).path.replace('\\', '/') }
        }
        return out.sorted()
    }

    private fun docFor(ctx: Context, path: String, create: Boolean): DocumentFile? {
        val root = DocumentFile.fromTreeUri(ctx, tree(ctx) ?: return null) ?: return null
        val parts = path.split('/').toMutableList()
        var d: DocumentFile = root.findFile("fw")?.takeIf { it.isDirectory }?.also { parts.removeAt(0) } ?: root.also { parts.removeAt(0) }
        for (p in parts.dropLast(1)) d = d.findFile(p) ?: return null
        return d.findFile(parts.last()) ?: if (create) d.createFile("text/plain", parts.last()) else null
    }

    fun read(ctx: Context, path: String): String {
        if (tree(ctx) != null) {
            val f = docFor(ctx, path, false) ?: return ""
            return ctx.contentResolver.openInputStream(f.uri)?.use { it.readBytes().toString(Charsets.UTF_8) } ?: ""
        }
        val f = File(internalDir(ctx), path)
        return if (f.isFile) f.readText() else ""
    }

    fun write(ctx: Context, path: String, text: String): Boolean = try {
        if (tree(ctx) != null) {
            val f = docFor(ctx, path, true) ?: throw Exception("no file")
            ctx.contentResolver.openOutputStream(f.uri, "wt")!!.use { it.write(text.toByteArray()) }
        } else File(internalDir(ctx), path).apply { parentFile?.mkdirs() }.writeText(text)
        true
    } catch (e: Exception) { false }

    /** Downloads the repository's fw/ and docs/ from GitHub into the app. */
    fun download(ctx: Context, progress: (String) -> Unit) {
        val c = URL("https://codeload.github.com/${Release.REPO}/zip/refs/heads/main").openConnection() as HttpURLConnection
        c.setRequestProperty("User-Agent", "open-pocket-android")
        c.instanceFollowRedirects = true
        if (c.responseCode != 200) throw Exception("GitHub: HTTP ${c.responseCode}")
        val base = internalDir(ctx)
        base.deleteRecursively()
        var n = 0
        ZipInputStream(c.inputStream.buffered()).use { z ->
            while (true) {
                val e = z.nextEntry ?: break
                val rel = e.name.substringAfter('/')                 // drop "open-pocket-gbc-main/"
                if (e.isDirectory || !(rel.startsWith("fw/") || rel.startsWith("docs/") && rel.endsWith(".md"))) continue
                if (!EXT.matches(rel) || ".." in rel) continue
                val f = File(base, rel)
                f.parentFile?.mkdirs()
                f.outputStream().use { z.copyTo(it) }
                if (++n % 20 == 0) progress("$n files")
            }
        }
        useTree(ctx, null)
        progress("$n files")
    }
}

/** The JavaScript side of the IDE page calls these. */
class IdeBridge(private val ctx: Context) {
    @JavascriptInterface fun files(): String = JSONArray(Sources.list(ctx)).toString()
    @JavascriptInterface fun read(path: String): String = Sources.read(ctx, path)
    @JavascriptInterface fun write(path: String, text: String): Boolean = Sources.write(ctx, path, text)
    @JavascriptInterface fun source(): String = Sources.describe(ctx)
}

@SuppressLint("SetJavaScriptEnabled")
fun ideWebView(ctx: Context): WebView {
    val loader = WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", WebViewAssetLoader.AssetsPathHandler(ctx))
        .addPathHandler("/data/") { path ->
            val f = if (path == "fw.bin") Sources.fwBin(ctx) else null
            if (f != null && f.isFile) WebResourceResponse("application/octet-stream", null, FileInputStream(f))
            else WebResourceResponse("text/plain", null, 404, "Not Found", emptyMap(), "".byteInputStream())
        }
        .build()
    return WebView(ctx).apply {
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        setBackgroundColor(android.graphics.Color.BLACK)
        addJavascriptInterface(IdeBridge(ctx), "Android")
        addOnLayoutChangeListener { v, _, _, _, _, _, _, _, _ ->
            val h = (v.height / ctx.resources.displayMetrics.density).toInt()
            (v as WebView).evaluateJavascript("window.setViewH && setViewH($h)", null)
        }
        webViewClient = object : WebViewClient() {
            override fun shouldInterceptRequest(view: WebView, req: WebResourceRequest): WebResourceResponse? =
                loader.shouldInterceptRequest(req.url)
            override fun onPageFinished(view: WebView, url: String) {
                val h = (view.height / ctx.resources.displayMetrics.density).toInt()
                view.evaluateJavascript("window.setViewH && setViewH($h)", null)
            }
        }
        loadUrl("https://appassets.androidplatform.net/assets/ide/index.html")
    }
}
