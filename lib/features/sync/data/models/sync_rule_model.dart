import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/sync_rule.dart';

SyncRuleType syncRuleTypeFromDb(String value) => switch (value) {
      'album' => SyncRuleType.album,
      'time_range' => SyncRuleType.timeRange,
      _ => throw ArgumentError('Unknown SyncRuleType: $value'),
    };

String syncRuleTypeToDb(SyncRuleType type) => switch (type) {
      SyncRuleType.album => 'album',
      SyncRuleType.timeRange => 'time_range',
    };

extension SyncRuleDbMapper on db.SyncRule {
  SyncRule toEntity() => SyncRule(
        id: id,
        type: syncRuleTypeFromDb(type),
        clusterId: clusterId,
        albumName: albumName,
        daysBack: daysBack,
        downloadFull: downloadFull,
        lastSyncedAt: lastSyncedAt,
        createdAt: createdAt,
      );
}

extension SyncRuleEntityMapper on SyncRule {
  db.SyncRulesCompanion toCompanion() => db.SyncRulesCompanion(
        id: id == 0 ? const Value.absent() : Value(id),
        type: Value(syncRuleTypeToDb(type)),
        clusterId: Value(clusterId),
        albumName: Value(albumName),
        daysBack: Value(daysBack),
        downloadFull: Value(downloadFull),
        lastSyncedAt: Value(lastSyncedAt),
        createdAt: Value(createdAt),
      );
}
