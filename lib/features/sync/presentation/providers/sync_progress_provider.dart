import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/sync_status.dart';
import '../../domain/usecases/run_sync_use_case.dart';
import 'sync_rules_provider.dart';

part 'sync_progress_provider.g.dart';

@riverpod
class SyncProgressNotifier extends _$SyncProgressNotifier {
  StreamSubscription<SyncProgress>? _subscription;

  @override
  SyncProgress build() {
    ref.onDispose(() => _subscription?.cancel());
    return SyncProgress.idle();
  }

  Future<void> startSync() async {
    if (state.status == SyncStatus.running) return;

    await _subscription?.cancel();
    _subscription = null;

    final repo = ref.read(syncRepositoryProvider);
    _subscription = RunSyncUseCase(repo)().listen(
      (progress) {
        state = progress;
        // A sync completato cambiano lastSyncedAt, conteggio file e spazio:
        // rinfresca lista regole e statistiche.
        if (progress.status == SyncStatus.idle) _refreshAfterSync();
      },
      onError: (e) => state = SyncProgress(
        status: SyncStatus.error,
        total: state.total,
        downloaded: state.downloaded,
        failed: state.failed + 1,
        currentFile: e.toString(),
      ),
    );
  }

  void _refreshAfterSync() {
    ref.invalidate(syncRulesProvider);
    ref.invalidate(syncTotalCacheBytesProvider);
    ref.invalidate(syncRuleStatsProvider);
  }

  Future<void> cancelSync() async {
    await _subscription?.cancel();
    _subscription = null;
    state = SyncProgress.idle();
  }
}
