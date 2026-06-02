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

  Future<WidgetAlbumConfig?> getConfigForWidget(int appWidgetId) async {
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
