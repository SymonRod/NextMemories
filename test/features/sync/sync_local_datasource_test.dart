import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_memories/core/database/app_database.dart';
import 'package:next_memories/features/sync/data/datasources/sync_local_datasource.dart';

AppDatabase _inMemoryDb() => AppDatabase(NativeDatabase.memory());

SyncRulesCompanion _albumRule({String clusterId = 'user/Vacanze'}) =>
    SyncRulesCompanion.insert(
      type: 'album',
      clusterId: Value(clusterId),
      albumName: Value('Vacanze'),
      downloadFull: const Value(false),
      createdAt: DateTime(2024, 1, 1),
    );

SyncCacheEntriesCompanion _cacheEntry({
  required int fileId,
  required int ruleId,
  bool downloadFull = false,
  String localPath = '/sync/1.jpg',
}) =>
    SyncCacheEntriesCompanion.insert(
      fileId: fileId,
      ruleId: ruleId,
      downloadFull: downloadFull,
      localPath: localPath,
      etag: 'abc',
      downloadedAt: DateTime(2024, 1, 2),
      sizeBytes: 1024,
    );

void main() {
  late AppDatabase database;
  late SyncLocalDatasource ds;

  setUp(() {
    database = _inMemoryDb();
    ds = SyncLocalDatasource(database);
  });

  tearDown(() => database.close());

  group('upsertRule', () {
    test('insert assegna un id > 0', () async {
      final row = await ds.upsertRule(_albumRule());
      expect(row.id, greaterThan(0));
      expect(row.type, 'album');
    });

    test('update mantiene lo stesso id e modifica i campi', () async {
      final inserted = await ds.upsertRule(_albumRule());
      final updated = await ds.upsertRule(
        SyncRulesCompanion(
          id: Value(inserted.id),
          downloadFull: const Value(true),
        ),
      );
      expect(updated.id, inserted.id);
      expect(updated.downloadFull, true);
    });

    test('due insert creano due righe distinte', () async {
      await ds.upsertRule(_albumRule(clusterId: 'user/A'));
      await ds.upsertRule(_albumRule(clusterId: 'user/B'));
      final rules = await ds.getRules();
      expect(rules.length, 2);
    });
  });

  group('countRefs (reference counting)', () {
    test('conta le righe su (fileId, downloadFull)', () async {
      final r1 = await ds.upsertRule(_albumRule(clusterId: 'user/A'));
      final r2 = await ds.upsertRule(_albumRule(clusterId: 'user/B'));

      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 10, ruleId: r1.id));
      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 10, ruleId: r2.id));

      expect(await ds.countRefs(10, false), 2);
    });

    test('excludeRuleId esclude la regola specificata', () async {
      final r1 = await ds.upsertRule(_albumRule(clusterId: 'user/A'));
      final r2 = await ds.upsertRule(_albumRule(clusterId: 'user/B'));

      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 10, ruleId: r1.id));
      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 10, ruleId: r2.id));

      // escludendo r1, rimane solo r2
      expect(await ds.countRefs(10, false, excludeRuleId: r1.id), 1);
    });

    test('downloadFull=true e false sono contati separatamente', () async {
      final r1 = await ds.upsertRule(_albumRule());

      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 10, ruleId: r1.id, downloadFull: false, localPath: '/sync/10.jpg'));
      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 10, ruleId: r1.id, downloadFull: true, localPath: '/sync/10_full.jpg'));

      expect(await ds.countRefs(10, false), 1);
      expect(await ds.countRefs(10, true), 1);
    });
  });

  group('deleteCacheEntriesForRule + deleteRule', () {
    test('cancella le righe della regola poi la regola stessa', () async {
      final rule = await ds.upsertRule(_albumRule());
      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 1, ruleId: rule.id));
      await ds.insertOrUpdateCacheEntry(_cacheEntry(fileId: 2, ruleId: rule.id));

      await ds.deleteCacheEntriesForRule(rule.id);
      expect(await ds.getCacheEntriesForRule(rule.id), isEmpty);

      await ds.deleteRule(rule.id);
      expect(await ds.getRules(), isEmpty);
    });
  });

  group('updateLastSyncedAt', () {
    test('aggiorna lastSyncedAt per la regola', () async {
      final rule = await ds.upsertRule(_albumRule());
      final ts = DateTime(2024, 6, 15);
      await ds.updateLastSyncedAt(rule.id, ts);
      final updated = (await ds.getRules()).first;
      expect(updated.lastSyncedAt, ts);
    });
  });
}
