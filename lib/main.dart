import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';

import 'core/router/app_router.dart';

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

class _NextMemoriesAppState extends ConsumerState<NextMemoriesApp> {
  StreamSubscription<Uri?>? _widgetClickSub;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _widgetClickSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
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
