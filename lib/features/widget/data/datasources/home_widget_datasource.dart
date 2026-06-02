import 'dart:convert';

import 'package:home_widget/home_widget.dart';

import '../../domain/entities/widget_album_config.dart';

/// Thin wrapper over the `home_widget` plugin. Writes the data consumed by the
/// native [AlbumWidgetProvider] and triggers a redraw.
///
/// The image is passed as a file path; downsampling to widget size happens on
/// the native side to avoid `TransactionTooLargeException`.
class HomeWidgetDatasource {
  // Must match the AppWidgetProvider declared in the Android manifest.
  static const _androidWidgetName = 'AlbumWidgetProvider';
  static const _qualifiedAndroidName =
      'com.simonerodino.next_memories.widgets.AlbumWidgetProvider';

  // Keys read by the native provider.
  static const keyImagePath = 'album_widget_image_path';
  static const keyAlbumName = 'album_widget_album_name';
  static const keyClusterId = 'album_widget_cluster_id';
  static const keyRuleId = 'album_widget_rule_id';
  static const keyConfiguredWidgetIds = 'album_widget_configured_ids';
  static const keyAvailableAlbums = 'album_widget_available_albums';
  static const keyLastShuffle = 'album_widget_last_shuffle';

  String _scopedKey(String baseKey, int? appWidgetId) {
    if (appWidgetId == null) return baseKey;
    return '${baseKey}_$appWidgetId';
  }

  Future<void> setData({
    required String imagePath,
    required String albumName,
    required String clusterId,
    int? ruleId,
    int? appWidgetId,
  }) async {
    await HomeWidget.saveWidgetData<String>(
      _scopedKey(keyImagePath, appWidgetId),
      imagePath,
    );
    await HomeWidget.saveWidgetData<String>(
      _scopedKey(keyAlbumName, appWidgetId),
      albumName,
    );
    await HomeWidget.saveWidgetData<String>(
      _scopedKey(keyClusterId, appWidgetId),
      clusterId,
    );
    if (ruleId != null) {
      await HomeWidget.saveWidgetData<int>(
        _scopedKey(keyRuleId, appWidgetId),
        ruleId,
      );
    }
  }

  Future<void> clearData({int? appWidgetId}) async {
    await HomeWidget.saveWidgetData<String?>(
      _scopedKey(keyImagePath, appWidgetId),
      null,
    );
    await HomeWidget.saveWidgetData<String?>(
      _scopedKey(keyAlbumName, appWidgetId),
      null,
    );
    await HomeWidget.saveWidgetData<String?>(
      _scopedKey(keyClusterId, appWidgetId),
      null,
    );
    await HomeWidget.saveWidgetData<int?>(
      _scopedKey(keyRuleId, appWidgetId),
      null,
    );
  }

  Future<List<int>> getConfiguredWidgetIds() async {
    final raw = await HomeWidget.getWidgetData<String>(
      keyConfiguredWidgetIds,
      defaultValue: '',
    );
    if (raw == null || raw.isEmpty) return const [];
    return raw
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toSet()
        .toList();
  }

  Future<void> removeConfiguredWidgetId(int appWidgetId) async {
    final ids = await getConfiguredWidgetIds();
    final next = ids.where((id) => id != appWidgetId).toList();
    await HomeWidget.saveWidgetData<String>(keyConfiguredWidgetIds, next.join(','));
  }

  /// Config of a specific widget instance (per-`appWidgetId` scoped keys, F1).
  Future<WidgetAlbumConfig?> getConfigForWidget(int appWidgetId) =>
      _readConfig(appWidgetId);

  /// Config written under the unscoped keys, i.e. the single pinned album of
  /// the legacy (pre-F1) flow. Readable without Hive, so the headless shuffle
  /// callback can use it as a fallback.
  Future<WidgetAlbumConfig?> getGlobalConfig() => _readConfig(null);

  Future<WidgetAlbumConfig?> _readConfig(int? appWidgetId) async {
    final ruleId = await HomeWidget.getWidgetData<int>(
      _scopedKey(keyRuleId, appWidgetId),
    );
    final clusterId = await HomeWidget.getWidgetData<String>(
      _scopedKey(keyClusterId, appWidgetId),
    );
    final albumName = await HomeWidget.getWidgetData<String>(
      _scopedKey(keyAlbumName, appWidgetId),
    );
    if (ruleId == null || clusterId == null || albumName == null) return null;
    return WidgetAlbumConfig(
      ruleId: ruleId,
      clusterId: clusterId,
      albumName: albumName,
    );
  }

  /// Returns true when a shuffle for [appWidgetId] ran less than [minGap] ago
  /// (and so should be skipped); otherwise records "now" and returns false.
  /// Backed by home_widget data (SharedPreferences), which is safe to touch
  /// from the headless isolate. Throttles bursts of taps on the widget.
  Future<bool> shouldThrottleShuffle(int? appWidgetId, Duration minGap) async {
    final key = _scopedKey(keyLastShuffle, appWidgetId);
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = await HomeWidget.getWidgetData<int>(key, defaultValue: 0) ?? 0;
    if (now - last < minGap.inMilliseconds) return true;
    await HomeWidget.saveWidgetData<int>(key, now);
    return false;
  }

  Future<void> saveAvailableAlbums(
    List<({WidgetAlbumConfig config, String? thumbnailPath})> albums,
  ) async {
    final json = jsonEncode(albums
        .map((a) => {
              'ruleId': a.config.ruleId,
              'clusterId': a.config.clusterId,
              'albumName': a.config.albumName,
              if (a.thumbnailPath != null) 'thumbnailPath': a.thumbnailPath,
            })
        .toList());
    await HomeWidget.saveWidgetData<String>(keyAvailableAlbums, json);
  }

  Future<void> update() async {
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      qualifiedAndroidName: _qualifiedAndroidName,
    );
  }
}
