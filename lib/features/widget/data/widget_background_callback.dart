import '../../../core/database/app_database.dart';
import '../../sync/data/datasources/sync_local_datasource.dart';
import 'datasources/home_widget_datasource.dart';
import 'datasources/widget_local_datasource.dart';
import 'widget_refresh_runner.dart';

/// Min gap between two shuffles of the same widget, to absorb rapid taps.
const _shuffleThrottle = Duration(milliseconds: 800);

/// Entry-point for the home_widget interactivity callback (F2).
///
/// Runs in a separate, headless Dart isolate with no ProviderScope/Riverpod and
/// no UI: every dependency is rebuilt from scratch. It needs neither auth nor
/// network — only the local Drift cache and the filesystem — because it just
/// re-picks an already-downloaded photo. Registered in `main()` via
/// `HomeWidget.registerInteractivityCallback`.
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  // The photo (R.id.widget_image) tap fires nextmemories://shuffle?widgetId=N.
  if (uri?.host != 'shuffle') return;

  final appWidgetId = int.tryParse(uri!.queryParameters['widgetId'] ?? '');

  final homeWidget = HomeWidgetDatasource();
  if (await homeWidget.shouldThrottleShuffle(appWidgetId, _shuffleThrottle)) {
    return;
  }

  // Open a dedicated Drift connection for this isolate; reads only, closed at
  // the end. SQLite tolerates this alongside the app's own connection.
  final db = AppDatabase();
  try {
    final syncLocal = SyncLocalDatasource(db);
    final runner = WidgetRefreshRunner(
      local: WidgetLocalDatasource(),
      homeWidget: homeWidget,
      getPaths: (ruleId) async {
        final entries = await syncLocal.getCacheEntriesForRule(ruleId);
        // Dedupe by fileId (a photo may be cached as both preview and original).
        final byFileId = <int, String>{};
        for (final e in entries) {
          byFileId.putIfAbsent(e.fileId, () => e.localPath);
        }
        return byFileId.values.toList();
      },
    );
    await runner.refreshScoped(appWidgetId);
  } finally {
    await db.close();
  }
}
