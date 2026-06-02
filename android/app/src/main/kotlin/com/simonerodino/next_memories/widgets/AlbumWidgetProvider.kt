package com.simonerodino.next_memories.widgets

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import com.simonerodino.next_memories.MainActivity
import com.simonerodino.next_memories.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

/**
 * Homescreen "digital frame" widget showing one photo from a synced album.
 *
 * Data is written by the Flutter side (see HomeWidgetDatasource) via the
 * home_widget plugin. The image arrives as a file path and is downsampled here
 * to stay well under the RemoteViews binder limit.
 */
class AlbumWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val imagePath = widgetData.getString(KEY_IMAGE_PATH, null)
        val albumName = widgetData.getString(KEY_ALBUM_NAME, null)
        val clusterId = widgetData.getString(KEY_CLUSTER_ID, null)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.album_widget)

            val bitmap = imagePath?.let { decodeSampledBitmap(it, TARGET_SIZE, TARGET_SIZE) }
            if (bitmap != null) {
                views.setImageViewBitmap(R.id.widget_image, bitmap)
                views.setViewVisibility(R.id.widget_image, View.VISIBLE)
                views.setViewVisibility(R.id.widget_empty, View.GONE)

                views.setTextViewText(R.id.widget_album_name, albumName ?: "")
                views.setViewVisibility(
                    R.id.widget_album_name,
                    if (albumName.isNullOrEmpty()) View.GONE else View.VISIBLE
                )
            } else {
                views.setViewVisibility(R.id.widget_image, View.GONE)
                views.setViewVisibility(R.id.widget_album_name, View.GONE)
                views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
            }

            // Tap opens the app; the deep link to the album is handled Flutter-side.
            val uri = clusterId?.let {
                Uri.parse(
                    "nextmemories://album" +
                        "?clusterId=${Uri.encode(it)}" +
                        "&name=${Uri.encode(albumName ?: "")}"
                )
            }
            val pendingIntent =
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, uri)
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun decodeSampledBitmap(path: String, reqWidth: Int, reqHeight: Int): Bitmap? {
        return try {
            if (!File(path).exists()) return null
            val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
            BitmapFactory.decodeFile(path, bounds)
            if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null

            BitmapFactory.Options().run {
                inSampleSize = calculateInSampleSize(bounds, reqWidth, reqHeight)
                // RGB_565 halves memory vs ARGB_8888: photos need no alpha channel and
                // this keeps the bitmap safely below the RemoteViews transaction limit.
                inPreferredConfig = Bitmap.Config.RGB_565
                BitmapFactory.decodeFile(path, this)
            }
        } catch (e: Exception) {
            null
        }
    }

    private fun calculateInSampleSize(
        options: BitmapFactory.Options,
        reqWidth: Int,
        reqHeight: Int
    ): Int {
        val height = options.outHeight
        val width = options.outWidth
        var inSampleSize = 1
        if (height > reqHeight || width > reqWidth) {
            val halfHeight = height / 2
            val halfWidth = width / 2
            while (halfHeight / inSampleSize >= reqHeight && halfWidth / inSampleSize >= reqWidth) {
                inSampleSize *= 2
            }
        }
        return inSampleSize
    }

    companion object {
        private const val TARGET_SIZE = 512

        // Must match the keys in HomeWidgetDatasource on the Flutter side.
        private const val KEY_IMAGE_PATH = "album_widget_image_path"
        private const val KEY_ALBUM_NAME = "album_widget_album_name"
        private const val KEY_CLUSTER_ID = "album_widget_cluster_id"
    }
}
