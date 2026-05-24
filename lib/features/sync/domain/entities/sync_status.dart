import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_status.freezed.dart';

enum SyncStatus { idle, running, paused, error }

@freezed
class SyncProgress with _$SyncProgress {
  const factory SyncProgress({
    required SyncStatus status,
    required int total,
    required int downloaded,
    required int failed,
    String? currentFile,
  }) = _SyncProgress;

  factory SyncProgress.idle() => const SyncProgress(
        status: SyncStatus.idle,
        total: 0,
        downloaded: 0,
        failed: 0,
      );
}
