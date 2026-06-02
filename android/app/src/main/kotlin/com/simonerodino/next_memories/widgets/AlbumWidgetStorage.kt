package com.simonerodino.next_memories.widgets

object AlbumWidgetStorage {
    const val PREFS_NAME = "HomeWidgetPreferences"

    const val KEY_IMAGE_PATH = "album_widget_image_path"
    const val KEY_ALBUM_NAME = "album_widget_album_name"
    const val KEY_CLUSTER_ID = "album_widget_cluster_id"
    const val KEY_RULE_ID = "album_widget_rule_id"
    const val KEY_CONFIGURED_WIDGET_IDS = "album_widget_configured_ids"
    const val KEY_AVAILABLE_ALBUMS = "album_widget_available_albums"

    fun scoped(baseKey: String, appWidgetId: Int): String = "${baseKey}_${appWidgetId}"

    fun parseWidgetIds(raw: String?): MutableSet<Int> {
        if (raw.isNullOrBlank()) return mutableSetOf()
        return raw.split(',')
            .mapNotNull { it.trim().toIntOrNull() }
            .toMutableSet()
    }

    fun serializeWidgetIds(ids: Set<Int>): String = ids.joinToString(",")
}
