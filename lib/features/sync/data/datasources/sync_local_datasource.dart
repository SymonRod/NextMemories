import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class SyncLocalDatasource {
  final AppDatabase _db;
  const SyncLocalDatasource(this._db);

  // --- SyncRules CRUD ---

  Future<List<SyncRule>> getRules() => _db.select(_db.syncRules).get();

  Future<SyncRule> upsertRule(SyncRulesCompanion companion) async {
    if (!companion.id.present || companion.id.value == 0) {
      final id = await _db.into(_db.syncRules).insert(companion);
      return (_db.select(_db.syncRules)..where((t) => t.id.equals(id))).getSingle();
    }
    await (_db.update(_db.syncRules)..where((t) => t.id.equals(companion.id.value)))
        .write(companion);
    return (_db.select(_db.syncRules)..where((t) => t.id.equals(companion.id.value)))
        .getSingle();
  }

  Future<void> deleteRule(int ruleId) =>
      (_db.delete(_db.syncRules)..where((t) => t.id.equals(ruleId))).go();

  Future<void> updateLastSyncedAt(int ruleId, DateTime syncedAt) =>
      (_db.update(_db.syncRules)..where((t) => t.id.equals(ruleId)))
          .write(SyncRulesCompanion(lastSyncedAt: Value(syncedAt)));

  // --- SyncCacheEntries CRUD ---

  Future<List<SyncCacheEntry>> getCacheEntriesForRule(int ruleId) =>
      (_db.select(_db.syncCacheEntries)..where((t) => t.ruleId.equals(ruleId))).get();

  Future<SyncCacheEntry?> getCacheEntry(int fileId, int ruleId, bool downloadFull) =>
      (_db.select(_db.syncCacheEntries)
            ..where((t) =>
                t.fileId.equals(fileId) &
                t.ruleId.equals(ruleId) &
                t.downloadFull.equals(downloadFull)))
          .getSingleOrNull();

  Future<void> insertOrUpdateCacheEntry(SyncCacheEntriesCompanion entry) =>
      _db.into(_db.syncCacheEntries).insertOnConflictUpdate(entry);

  Future<void> deleteCacheEntry(int fileId, int ruleId, bool downloadFull) =>
      (_db.delete(_db.syncCacheEntries)
            ..where((t) =>
                t.fileId.equals(fileId) &
                t.ruleId.equals(ruleId) &
                t.downloadFull.equals(downloadFull)))
          .go();

  Future<void> deleteCacheEntriesForRule(int ruleId) =>
      (_db.delete(_db.syncCacheEntries)..where((t) => t.ruleId.equals(ruleId))).go();

  Future<String?> getLocalPath(int fileId) async {
    final entries = await (_db.select(_db.syncCacheEntries)
          ..where((t) => t.fileId.equals(fileId)))
        .get();
    if (entries.isEmpty) return null;
    // Prefer original (higher quality) over preview
    final original = entries.where((e) => e.downloadFull).firstOrNull;
    return (original ?? entries.first).localPath;
  }

  Future<({int fileCount, int sizeBytes})> getCacheStatsForRule(int ruleId) async {
    final entries = await getCacheEntriesForRule(ruleId);
    final total = entries.fold(0, (sum, e) => sum + e.sizeBytes);
    return (fileCount: entries.length, sizeBytes: total);
  }

  Future<int> getTotalCacheBytes() async {
    final all = await _db.select(_db.syncCacheEntries).get();
    final seen = <String>{};
    var total = 0;
    for (final e in all) {
      if (seen.add('${e.fileId}:${e.downloadFull}')) total += e.sizeBytes;
    }
    return total;
  }

  // Conta quante righe in cache referenziano (fileId, downloadFull),
  // escludendo opzionalmente una regola specifica (per il reference counting
  // prima della cancellazione di una regola).
  Future<int> countRefs(
    int fileId,
    bool downloadFull, {
    int? excludeRuleId,
  }) async {
    final rows = await (_db.select(_db.syncCacheEntries)
          ..where((t) => t.fileId.equals(fileId) & t.downloadFull.equals(downloadFull)))
        .get();
    if (excludeRuleId == null) return rows.length;
    return rows.where((r) => r.ruleId != excludeRuleId).length;
  }
}
