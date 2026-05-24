import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_rule.freezed.dart';

enum SyncRuleType { album, timeRange }

@freezed
class SyncRule with _$SyncRule {
  const factory SyncRule({
    required int id,
    required SyncRuleType type,
    String? clusterId,
    String? albumName,
    int? daysBack,
    required bool downloadFull,
    DateTime? lastSyncedAt,
    required DateTime createdAt,
  }) = _SyncRule;
}
