import 'package:flutter_test/flutter_test.dart';
import 'package:next_memories/core/database/app_database.dart' as db;
import 'package:next_memories/features/sync/data/models/sync_rule_model.dart';
import 'package:next_memories/features/sync/domain/entities/sync_rule.dart';

void main() {
  final now = DateTime(2024, 1, 15, 12, 0);

  db.SyncRule makeDbRow({
    int id = 1,
    String type = 'album',
    String? clusterId = 'user/My Album',
    String? albumName = 'My Album',
    int? daysBack,
    bool downloadFull = false,
    DateTime? lastSyncedAt,
  }) =>
      db.SyncRule(
        id: id,
        type: type,
        clusterId: clusterId,
        albumName: albumName,
        daysBack: daysBack,
        downloadFull: downloadFull,
        lastSyncedAt: lastSyncedAt,
        createdAt: now,
      );

  group('SyncRuleDbMapper.toEntity', () {
    test('mappa album row → entity', () {
      final row = makeDbRow(type: 'album', clusterId: 'user/Vacanze', albumName: 'Vacanze');
      final entity = row.toEntity();

      expect(entity.id, 1);
      expect(entity.type, SyncRuleType.album);
      expect(entity.clusterId, 'user/Vacanze');
      expect(entity.albumName, 'Vacanze');
      expect(entity.daysBack, isNull);
      expect(entity.downloadFull, false);
      expect(entity.createdAt, now);
    });

    test('mappa time_range row → entity', () {
      final row = makeDbRow(type: 'time_range', clusterId: null, albumName: null, daysBack: 30);
      final entity = row.toEntity();

      expect(entity.type, SyncRuleType.timeRange);
      expect(entity.daysBack, 30);
      expect(entity.clusterId, isNull);
    });

    test('type sconosciuto lancia ArgumentError', () {
      final row = makeDbRow(type: 'unknown');
      expect(row.toEntity, throwsArgumentError);
    });
  });

  group('SyncRuleEntityMapper.toCompanion', () {
    test('id == 0 produce Value.absent per auto-increment', () {
      final entity = SyncRule(
        id: 0,
        type: SyncRuleType.album,
        clusterId: 'user/Test',
        albumName: 'Test',
        daysBack: null,
        downloadFull: false,
        lastSyncedAt: null,
        createdAt: now,
      );
      final companion = entity.toCompanion();

      expect(companion.id.present, false);
      expect(companion.type.value, 'album');
      expect(companion.clusterId.value, 'user/Test');
    });

    test('id > 0 produce Value(id) per update', () {
      final entity = SyncRule(
        id: 42,
        type: SyncRuleType.timeRange,
        clusterId: null,
        albumName: null,
        daysBack: 90,
        downloadFull: true,
        lastSyncedAt: null,
        createdAt: now,
      );
      final companion = entity.toCompanion();

      expect(companion.id.value, 42);
      expect(companion.type.value, 'time_range');
      expect(companion.daysBack.value, 90);
      expect(companion.downloadFull.value, true);
    });

    test('round-trip: toCompanion → toEntity preserva tutti i campi', () {
      final original = SyncRule(
        id: 5,
        type: SyncRuleType.album,
        clusterId: 'user/Album',
        albumName: 'Album',
        daysBack: null,
        downloadFull: false,
        lastSyncedAt: null,
        createdAt: now,
      );
      final companion = original.toCompanion();
      final row = db.SyncRule(
        id: companion.id.value,
        type: companion.type.value,
        clusterId: companion.clusterId.value,
        albumName: companion.albumName.value,
        daysBack: companion.daysBack.value,
        downloadFull: companion.downloadFull.value,
        lastSyncedAt: companion.lastSyncedAt.value,
        createdAt: companion.createdAt.value,
      );
      final restored = row.toEntity();

      expect(restored, original);
    });
  });
}
