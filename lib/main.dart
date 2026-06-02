import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';

import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/sync/domain/entities/sync_rule.dart';
import 'features/sync/domain/entities/sync_status.dart';
import 'features/sync/presentation/providers/sync_progress_provider.dart';
import 'features/sync/presentation/providers/sync_rules_provider.dart';
import 'features/widget/data/datasources/home_widget_datasource.dart';
import 'features/widget/domain/entities/widget_album_config.dart';
import 'features/widget/presentation/providers/widget_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(
    const ProviderScope(
      child: NextMemoriesApp(),
    ),
  );
}

class NextMemoriesApp extends ConsumerStatefulWidget {
  const NextMemoriesApp({super.key});

  @override
  ConsumerState<NextMemoriesApp> createState() => _NextMemoriesAppState();
}

class _NextMemoriesAppState extends ConsumerState<NextMemoriesApp>
    with WidgetsBindingObserver {
  StreamSubscription<Uri?>? _widgetClickSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Defer until the router delegate is attached so navigation lands correctly.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initWidgetClicks());
  }

  Future<void> _initWidgetClicks() async {
    // Cold start: app launched by tapping the widget.
    final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    if (launchUri != null) _handleWidgetUri(launchUri);
    // Warm taps while the app is already running.
    _widgetClickSub = HomeWidget.widgetClicked.listen((uri) {
      if (uri != null) _handleWidgetUri(uri);
    });
  }

  void _handleWidgetUri(Uri uri) {
    if (uri.host != 'album') return;
    final clusterId = uri.queryParameters['clusterId'];
    if (clusterId == null) return;
    final name = uri.queryParameters['name'] ?? '';
    ref.read(appRouterProvider).push(
      '/album-detail',
      extra: {'clusterId': clusterId, 'name': name},
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Rotate the widget photo each time the app returns to the foreground.
    if (state == AppLifecycleState.resumed) _refreshWidget();
  }

  void _saveAvailableWidgetAlbums(List<SyncRule> rules) {
    _saveAvailableWidgetAlbumsAsync(rules);
  }

  Future<void> _saveAvailableWidgetAlbumsAsync(List<SyncRule> rules) async {
    try {
      final syncRepo = ref.read(syncRepositoryProvider);
      final albumRules = rules.where(
        (r) => r.type == SyncRuleType.album && r.clusterId != null && r.albumName != null,
      );
      final entries = <({WidgetAlbumConfig config, String? thumbnailPath})>[];
      for (final rule in albumRules) {
        final pathsResult = await syncRepo.getLocalPhotoPathsForRule(rule.id);
        final paths = pathsResult.getOrElse((_) => <String>[]);
        final thumbnail = paths.firstWhere((p) => File(p).existsSync(), orElse: () => '');
        entries.add((
          config: WidgetAlbumConfig(ruleId: rule.id, clusterId: rule.clusterId!, albumName: rule.albumName!),
          thumbnailPath: thumbnail.isEmpty ? null : thumbnail,
        ));
      }
      await HomeWidgetDatasource().saveAvailableAlbums(entries);
    } catch (_) {
      // Not authenticated or sync repo unavailable: skip silently.
    }
  }

  /// Re-picks a photo for the pinned album. No-op if nothing is pinned, and
  /// guarded by auth since the widget repository depends on the sync repository.
  void _refreshWidget() {
    if (ref.read(authProvider).valueOrNull == null) return;
    try {
      ref.read(widgetRepositoryProvider).refreshWidget();
    } catch (_) {
      // Not authenticated yet / provider unavailable: ignore.
    }
  }

  @override
  void dispose() {
    _widgetClickSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    // Refresh the widget when a sync run completes (cache contents changed).
    ref.listen<SyncProgress>(syncProgressNotifierProvider, (prev, next) {
      if (prev?.status == SyncStatus.running && next.status == SyncStatus.idle) {
        _refreshWidget();
      }
    });

    // Keep the native config-activity album list up to date whenever sync rules change.
    ref.listen<AsyncValue<List<SyncRule>>>(
      syncRulesProvider,
      (_, next) => next.whenData(_saveAvailableWidgetAlbums),
    );

    return MaterialApp.router(
      title: 'Next Memories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
