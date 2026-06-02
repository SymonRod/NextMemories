// ignore_for_file: prefer_initializing_formals
import 'dart:io';
import 'dart:math';

import '../domain/entities/widget_album_config.dart';
import 'datasources/home_widget_datasource.dart';
import 'datasources/widget_local_datasource.dart';

/// Looks up the local photo paths cached for a sync rule.
typedef PhotoPathsLookup = Future<List<String>> Function(int ruleId);

/// Picks a photo for the album widget(s) and pushes it to the native side.
///
/// Holds no Riverpod/UI dependency, so the same pipeline can run from the app
/// (MVP), from the interactivity callback in a headless isolate (F2) and from
/// future background work (F3). The only injected I/O is [PhotoPathsLookup],
/// which the app backs with the authenticated sync repository and the headless
/// isolate backs with a direct (auth-free) Drift read.
class WidgetRefreshRunner {
  final WidgetLocalDatasource _local;
  final HomeWidgetDatasource _homeWidget;
  final PhotoPathsLookup _getPaths;
  final Random _random;

  WidgetRefreshRunner({
    required WidgetLocalDatasource local,
    required HomeWidgetDatasource homeWidget,
    required PhotoPathsLookup getPaths,
    Random? random,
  })  : _local = local,
        _homeWidget = homeWidget,
        _getPaths = getPaths,
        _random = random ?? Random();

  /// MVP path (main isolate): refresh every configured per-widget instance, or
  /// the single pinned album when no per-widget config exists. Reads the pinned
  /// album from Hive, so it must run on the isolate that owns that box.
  Future<void> refreshAll() async {
    final configuredWidgetIds = await _homeWidget.getConfiguredWidgetIds();
    if (configuredWidgetIds.isNotEmpty) {
      for (final widgetId in configuredWidgetIds) {
        final config = await _homeWidget.getConfigForWidget(widgetId);
        if (config == null) {
          await _homeWidget.clearData(appWidgetId: widgetId);
          await _homeWidget.removeConfiguredWidgetId(widgetId);
          continue;
        }
        final updated = await refreshSingle(config, appWidgetId: widgetId);
        if (!updated) await _homeWidget.clearData(appWidgetId: widgetId);
      }
      await _homeWidget.update();
      return;
    }

    final config = await _local.getPinnedAlbum();
    if (config == null) {
      await clearWidget();
      return;
    }
    final updated = await refreshSingle(config);
    if (!updated) {
      await clearWidget();
      return;
    }
    await _homeWidget.update();
  }

  /// F2 path: re-pick a photo for a single widget instance. Reads the config
  /// from home_widget data only (per-widget scoped keys, falling back to the
  /// global ones) and never touches Hive, so it is safe to run in a separate
  /// isolate while the app may have the Hive box open. When [appWidgetId] is
  /// null only the global config is used.
  Future<void> refreshScoped(int? appWidgetId) async {
    final scoped =
        appWidgetId == null ? null : await _homeWidget.getConfigForWidget(appWidgetId);
    final config = scoped ?? await _homeWidget.getGlobalConfig();
    if (config == null) return;
    final updated = await refreshSingle(config, appWidgetId: appWidgetId);
    if (!updated) await _homeWidget.clearData(appWidgetId: appWidgetId);
    await _homeWidget.update();
  }

  /// Picks a random still-on-disk photo for [config] and writes it to the
  /// widget data (scoped to [appWidgetId] when given). Returns false when the
  /// album has no available file, so the caller can clear the instance.
  Future<bool> refreshSingle(WidgetAlbumConfig config, {int? appWidgetId}) async {
    final paths = await _getPaths(config.ruleId);
    // Keep only files still present on disk.
    final existing = paths.where((p) => File(p).existsSync()).toList();
    if (existing.isEmpty) return false;

    final pick = existing[_random.nextInt(existing.length)];
    await _homeWidget.setData(
      imagePath: pick,
      albumName: config.albumName,
      clusterId: config.clusterId,
      ruleId: config.ruleId,
      appWidgetId: appWidgetId,
    );
    return true;
  }

  Future<void> clearWidget() async {
    await _homeWidget.clearData();
    await _homeWidget.update();
  }
}
