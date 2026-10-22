package io.github.lakomoor.openpocket

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

/** The latest GitHub release and writing its update files to the root of an SD card. */
object Release {
    const val REPO = "LakoMoor/open-pocket-gbc"
    val FILES = listOf("opgbc_fw.bin", "opgbc_fpga.bin")

    data class Asset(val name: String, val size: Long, val url: String)
    data class Info(val tag: String, val name: String, val date: String, val assets: List<Asset>)

    private fun open(url: String): HttpURLConnection =
        (URL(url).openConnection() as HttpURLConnection).apply {
            setRequestProperty("User-Agent", "open-pocket-android")
            connectTimeout = 15000
            readTimeout = 30000
            instanceFollowRedirects = true
        }

    fun latest(): Info {
        val c = open("https://api.github.com/repos/$REPO/releases/latest")
        c.setRequestProperty("Accept", "application/vnd.github+json")
        if (c.responseCode == 404) throw Exception("No release published yet")
        if (c.responseCode != 200) throw Exception("GitHub: HTTP ${c.responseCode}")
        val j = JSONObject(c.inputStream.bufferedReader().readText())
        val arr = j.getJSONArray("assets")
        val assets = (0 until arr.length()).map { arr.getJSONObject(it) }
            .filter { it.getString("name") in FILES }
            .map { Asset(it.getString("name"), it.getLong("size"), it.getString("browser_download_url")) }
        return Info(j.getString("tag_name"), j.optString("name"), j.optString("published_at").take(10), assets)
    }

    /** Downloads one asset to a local file; progress 0..1. */
    fun download(a: Asset, dest: java.io.File, progress: (Float) -> Unit) {
        val c = open(a.url)
        c.setRequestProperty("Accept", "application/octet-stream")
        if (c.responseCode != 200) throw Exception("GitHub: HTTP ${c.responseCode}")
        val total = if (c.contentLengthLong > 0) c.contentLengthLong else a.size
        dest.parentFile?.mkdirs()
        val tmp = java.io.File(dest.path + ".part")
        tmp.outputStream().use { out ->
            c.inputStream.use { inp ->
                val buf = ByteArray(32768)
                var got = 0L
                while (true) {
                    val n = inp.read(buf)
                    if (n < 0) break
                    out.write(buf, 0, n)
                    got += n
                    progress((got.toFloat() / total).coerceIn(0f, 1f))
                }
            }
        }
        if (!tmp.renameTo(dest)) { dest.delete(); tmp.renameTo(dest) }
    }

    /** Downloads every asset into the chosen folder (the SD card root); progress 0..1. */
    fun saveTo(ctx: Context, tree: Uri, info: Info, progress: (String, Float) -> Unit): List<String> {
        val dir = DocumentFile.fromTreeUri(ctx, tree) ?: throw Exception("Can't open the folder")
        val done = mutableListOf<String>()
        for (a in info.assets) {
            dir.findFile(a.name)?.delete()
            val f = dir.createFile("application/octet-stream", a.name) ?: throw Exception("Can't create ${a.name}")
            // createFile may append ".bin" again for this MIME type: rename back if needed
            if (f.name != a.name) f.renameTo(a.name)
            val c = open(a.url)
            c.setRequestProperty("Accept", "application/octet-stream")
            val total = if (c.contentLengthLong > 0) c.contentLengthLong else a.size
            ctx.contentResolver.openOutputStream(f.uri, "wt")!!.use { out ->
                c.inputStream.use { inp ->
                    val buf = ByteArray(32768)
                    var got = 0L
                    while (true) {
                        val n = inp.read(buf)
                        if (n < 0) break
                        out.write(buf, 0, n)
                        got += n
                        progress(a.name, (got.toFloat() / total).coerceIn(0f, 1f))
                    }
                }
            }
            done += a.name
        }
        return done
    }
}
