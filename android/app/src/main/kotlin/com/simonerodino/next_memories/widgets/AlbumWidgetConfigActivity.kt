package com.simonerodino.next_memories.widgets

import android.app.Activity
import android.app.AlertDialog
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageView
import android.widget.ListView
import android.widget.TextView
import android.widget.Toast
import com.simonerodino.next_memories.R
import org.json.JSONArray
import java.io.File

/**
 * Config activity for the Album widget.
 *
 * Opens when the user drags the widget onto the homescreen (initial config)
 * or long-presses it (reconfiguration via android:widgetFeatures="reconfigurable").
 *
 * Reads the list of syncable albums written by the Flutter side
 * (HomeWidgetDatasource.saveAvailableAlbums) and shows a custom picker with
 * album thumbnails. Each widget instance stores its own config under
 * per-appWidgetId scoped keys.
 */
class AlbumWidgetConfigActivity : Activity() {

    private var appWidgetId: Int = AppWidgetManager.INVALID_APPWIDGET_ID

    private data class AlbumChoice(
        val ruleId: Int,
        val clusterId: String,
        val albumName: String,
        val thumbnailPath: String? = null,
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setResult(RESULT_CANCELED)

        appWidgetId =
            intent?.extras?.getInt(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID,
            ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        val prefs = getSharedPreferences(AlbumWidgetStorage.PREFS_NAME, MODE_PRIVATE)
        val albums = parseAvailableAlbums(prefs.getString(AlbumWidgetStorage.KEY_AVAILABLE_ALBUMS, null))

        if (albums.isEmpty()) {
            Toast.makeText(
                this,
                "Apri l'app e sincronizza un album prima di aggiungere il widget.",
                Toast.LENGTH_LONG,
            ).show()
            finish()
            return
        }

        if (albums.size == 1) {
            configureWidget(albums[0])
            return
        }

        showAlbumPicker(albums)
    }

    private fun showAlbumPicker(albums: List<AlbumChoice>) {
        val listView = ListView(this).apply {
            adapter = AlbumPickerAdapter(albums)
            dividerHeight = 0
        }

        val dialog = AlertDialog.Builder(this)
            .setTitle("Scegli album da mostrare")
            .setView(listView)
            .setNegativeButton("Annulla") { _, _ -> finish() }
            .setOnCancelListener { finish() }
            .create()

        listView.setOnItemClickListener { _, _, position, _ ->
            dialog.dismiss()
            configureWidget(albums[position])
        }

        dialog.show()
    }

    private fun configureWidget(album: AlbumChoice) {
        val prefs = getSharedPreferences(AlbumWidgetStorage.PREFS_NAME, MODE_PRIVATE)

        val ids = AlbumWidgetStorage.parseWidgetIds(
            prefs.getString(AlbumWidgetStorage.KEY_CONFIGURED_WIDGET_IDS, ""),
        )
        ids.add(appWidgetId)

        prefs.edit()
            .putString(AlbumWidgetStorage.scoped(AlbumWidgetStorage.KEY_CLUSTER_ID, appWidgetId), album.clusterId)
            .putString(AlbumWidgetStorage.scoped(AlbumWidgetStorage.KEY_ALBUM_NAME, appWidgetId), album.albumName)
            .putInt(AlbumWidgetStorage.scoped(AlbumWidgetStorage.KEY_RULE_ID, appWidgetId), album.ruleId)
            .putString(
                AlbumWidgetStorage.KEY_CONFIGURED_WIDGET_IDS,
                AlbumWidgetStorage.serializeWidgetIds(ids),
            )
            .apply()

        sendBroadcast(Intent(this, AlbumWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(appWidgetId))
        })

        setResult(RESULT_OK, Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId))
        finish()
    }

    // --- Adapter ---

    private inner class AlbumPickerAdapter(private val items: List<AlbumChoice>) : BaseAdapter() {

        override fun getCount() = items.size
        override fun getItem(position: Int) = items[position]
        override fun getItemId(position: Int) = position.toLong()

        override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
            val view = convertView
                ?: LayoutInflater.from(this@AlbumWidgetConfigActivity)
                    .inflate(R.layout.album_picker_item, parent, false)

            val album = items[position]
            view.findViewById<TextView>(R.id.item_album_name).text = album.albumName

            val thumbnail = view.findViewById<ImageView>(R.id.item_thumbnail)
            val bitmap = album.thumbnailPath?.let { loadThumbnail(it, THUMBNAIL_SIZE) }
            if (bitmap != null) {
                thumbnail.setImageBitmap(bitmap)
            } else {
                thumbnail.setImageDrawable(null)
            }

            return view
        }
    }

    // --- Helpers ---

    private fun parseAvailableAlbums(json: String?): List<AlbumChoice> {
        if (json.isNullOrBlank()) return emptyList()
        return try {
            val arr = JSONArray(json)
            (0 until arr.length()).map { i ->
                val obj = arr.getJSONObject(i)
                AlbumChoice(
                    ruleId = obj.getInt("ruleId"),
                    clusterId = obj.getString("clusterId"),
                    albumName = obj.getString("albumName"),
                    thumbnailPath = if (obj.has("thumbnailPath")) obj.getString("thumbnailPath") else null,
                )
            }
        } catch (_: Exception) {
            emptyList()
        }
    }

    private fun loadThumbnail(path: String, size: Int): Bitmap? {
        return try {
            if (!File(path).exists()) return null
            val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
            BitmapFactory.decodeFile(path, bounds)
            if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null
            BitmapFactory.Options().run {
                inSampleSize = calculateInSampleSize(bounds, size, size)
                inPreferredConfig = Bitmap.Config.RGB_565
                BitmapFactory.decodeFile(path, this)
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun calculateInSampleSize(options: BitmapFactory.Options, reqWidth: Int, reqHeight: Int): Int {
        var inSampleSize = 1
        if (options.outHeight > reqHeight || options.outWidth > reqWidth) {
            val halfHeight = options.outHeight / 2
            val halfWidth = options.outWidth / 2
            while (halfHeight / inSampleSize >= reqHeight && halfWidth / inSampleSize >= reqWidth) {
                inSampleSize *= 2
            }
        }
        return inSampleSize
    }

    companion object {
        private const val THUMBNAIL_SIZE = 128
    }
}
