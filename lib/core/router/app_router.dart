import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

// Placeholder screens — verranno sostituiti dalle feature reali
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen(this.label);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(label)));
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/timeline',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      if (authState.isLoading) return null;

      final isAuthenticated = authState.valueOrNull != null;
      final onAuthPage = state.matchedLocation == '/auth';

      if (!isAuthenticated && !onAuthPage) return '/auth';
      if (isAuthenticated && onAuthPage) return '/timeline';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/timeline',
            builder: (context, state) => const _PlaceholderScreen('Timeline'),
          ),
          GoRoute(
            path: '/albums',
            builder: (context, state) => const _PlaceholderScreen('Albums'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  int _selectedIndex(String path) {
    if (path.startsWith('/albums')) return 1;
    if (path.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (i) {
          if (i == 0) context.go('/timeline');
          if (i == 1) context.go('/albums');
          if (i == 2) context.go('/profile');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.photo_library), label: 'Timeline'),
          NavigationDestination(icon: Icon(Icons.photo_album), label: 'Album'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profilo'),
        ],
      ),
    );
  }
}
