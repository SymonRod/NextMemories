import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/widget_album_config.dart';

/// Persists the album pinned to the homescreen widget (user preference → Hive).
class WidgetLocalDatasource {
  static const _boxName = 'widget_prefs';
  static const _pinnedKey = 'pinned_album';

  Box<dynamic>? _box;

  Future<Box<dynamic>> _open() async {
    _box ??= await Hive.openBox<dynamic>(_boxName);
    return _box!;
  }

  Future<WidgetAlbumConfig?> getPinnedAlbum() async {
    final box = await _open();
    final raw = box.get(_pinnedKey);
    if (raw == null) return null;
    final m = raw as Map;
    return WidgetAlbumConfig(
      ruleId: m['ruleId'] as int,
      clusterId: m['clusterId'] as String,
      albumName: m['albumName'] as String,
    );
  }

  Future<void> setPinnedAlbum(WidgetAlbumConfig config) async {
    final box = await _open();
    await box.put(_pinnedKey, {
      'ruleId': config.ruleId,
      'clusterId': config.clusterId,
      'albumName': config.albumName,
    });
  }

  Future<void> clearPinnedAlbum() async {
    final box = await _open();
    await box.delete(_pinnedKey);
  }
}
