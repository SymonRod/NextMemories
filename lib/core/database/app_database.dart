import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

class SyncRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'album' | 'time_range'
  TextColumn get clusterId => text().nullable()();
  TextColumn get albumName => text().nullable()();
  IntColumn get daysBack => integer().nullable()();
  BoolColumn get downloadFull => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class SyncCacheEntries extends Table {
  // Composite PK: (fileId, ruleId, downloadFull)
  // downloadFull è parte della PK perché una stessa foto con due regole
  // a qualità diversa produce due file fisici distinti sul disco.
  IntColumn get fileId => integer()();
  IntColumn get ruleId => integer().references(SyncRules, #id)();
  BoolColumn get downloadFull => boolean()();
  TextColumn get localPath => text()();
  TextColumn get etag => text()();
  DateTimeColumn get downloadedAt => dateTime()();
  IntColumn get sizeBytes => integer()();

  @override
  Set<Column> get primaryKey => {fileId, ruleId, downloadFull};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [SyncRules, SyncCacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {},
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'next_memories.db'));
    return NativeDatabase.createInBackground(file);
  });
}
