// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SyncRulesTable extends SyncRules
    with TableInfo<$SyncRulesTable, SyncRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clusterIdMeta = const VerificationMeta(
    'clusterId',
  );
  @override
  late final GeneratedColumn<String> clusterId = GeneratedColumn<String>(
    'cluster_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumNameMeta = const VerificationMeta(
    'albumName',
  );
  @override
  late final GeneratedColumn<String> albumName = GeneratedColumn<String>(
    'album_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _daysBackMeta = const VerificationMeta(
    'daysBack',
  );
  @override
  late final GeneratedColumn<int> daysBack = GeneratedColumn<int>(
    'days_back',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadFullMeta = const VerificationMeta(
    'downloadFull',
  );
  @override
  late final GeneratedColumn<bool> downloadFull = GeneratedColumn<bool>(
    'download_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("download_full" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    clusterId,
    albumName,
    daysBack,
    downloadFull,
    lastSyncedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('cluster_id')) {
      context.handle(
        _clusterIdMeta,
        clusterId.isAcceptableOrUnknown(data['cluster_id']!, _clusterIdMeta),
      );
    }
    if (data.containsKey('album_name')) {
      context.handle(
        _albumNameMeta,
        albumName.isAcceptableOrUnknown(data['album_name']!, _albumNameMeta),
      );
    }
    if (data.containsKey('days_back')) {
      context.handle(
        _daysBackMeta,
        daysBack.isAcceptableOrUnknown(data['days_back']!, _daysBackMeta),
      );
    }
    if (data.containsKey('download_full')) {
      context.handle(
        _downloadFullMeta,
        downloadFull.isAcceptableOrUnknown(
          data['download_full']!,
          _downloadFullMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      clusterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cluster_id'],
      ),
      albumName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_name'],
      ),
      daysBack: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_back'],
      ),
      downloadFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}download_full'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncRulesTable createAlias(String alias) {
    return $SyncRulesTable(attachedDatabase, alias);
  }
}

class SyncRule extends DataClass implements Insertable<SyncRule> {
  final int id;
  final String type;
  final String? clusterId;
  final String? albumName;
  final int? daysBack;
  final bool downloadFull;
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  const SyncRule({
    required this.id,
    required this.type,
    this.clusterId,
    this.albumName,
    this.daysBack,
    required this.downloadFull,
    this.lastSyncedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || clusterId != null) {
      map['cluster_id'] = Variable<String>(clusterId);
    }
    if (!nullToAbsent || albumName != null) {
      map['album_name'] = Variable<String>(albumName);
    }
    if (!nullToAbsent || daysBack != null) {
      map['days_back'] = Variable<int>(daysBack);
    }
    map['download_full'] = Variable<bool>(downloadFull);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncRulesCompanion toCompanion(bool nullToAbsent) {
    return SyncRulesCompanion(
      id: Value(id),
      type: Value(type),
      clusterId: clusterId == null && nullToAbsent
          ? const Value.absent()
          : Value(clusterId),
      albumName: albumName == null && nullToAbsent
          ? const Value.absent()
          : Value(albumName),
      daysBack: daysBack == null && nullToAbsent
          ? const Value.absent()
          : Value(daysBack),
      downloadFull: Value(downloadFull),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      createdAt: Value(createdAt),
    );
  }

  factory SyncRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncRule(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      clusterId: serializer.fromJson<String?>(json['clusterId']),
      albumName: serializer.fromJson<String?>(json['albumName']),
      daysBack: serializer.fromJson<int?>(json['daysBack']),
      downloadFull: serializer.fromJson<bool>(json['downloadFull']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'clusterId': serializer.toJson<String?>(clusterId),
      'albumName': serializer.toJson<String?>(albumName),
      'daysBack': serializer.toJson<int?>(daysBack),
      'downloadFull': serializer.toJson<bool>(downloadFull),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncRule copyWith({
    int? id,
    String? type,
    Value<String?> clusterId = const Value.absent(),
    Value<String?> albumName = const Value.absent(),
    Value<int?> daysBack = const Value.absent(),
    bool? downloadFull,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    DateTime? createdAt,
  }) => SyncRule(
    id: id ?? this.id,
    type: type ?? this.type,
    clusterId: clusterId.present ? clusterId.value : this.clusterId,
    albumName: albumName.present ? albumName.value : this.albumName,
    daysBack: daysBack.present ? daysBack.value : this.daysBack,
    downloadFull: downloadFull ?? this.downloadFull,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncRule copyWithCompanion(SyncRulesCompanion data) {
    return SyncRule(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      clusterId: data.clusterId.present ? data.clusterId.value : this.clusterId,
      albumName: data.albumName.present ? data.albumName.value : this.albumName,
      daysBack: data.daysBack.present ? data.daysBack.value : this.daysBack,
      downloadFull: data.downloadFull.present
          ? data.downloadFull.value
          : this.downloadFull,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncRule(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('clusterId: $clusterId, ')
          ..write('albumName: $albumName, ')
          ..write('daysBack: $daysBack, ')
          ..write('downloadFull: $downloadFull, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    clusterId,
    albumName,
    daysBack,
    downloadFull,
    lastSyncedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncRule &&
          other.id == this.id &&
          other.type == this.type &&
          other.clusterId == this.clusterId &&
          other.albumName == this.albumName &&
          other.daysBack == this.daysBack &&
          other.downloadFull == this.downloadFull &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.createdAt == this.createdAt);
}

class SyncRulesCompanion extends UpdateCompanion<SyncRule> {
  final Value<int> id;
  final Value<String> type;
  final Value<String?> clusterId;
  final Value<String?> albumName;
  final Value<int?> daysBack;
  final Value<bool> downloadFull;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime> createdAt;
  const SyncRulesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.clusterId = const Value.absent(),
    this.albumName = const Value.absent(),
    this.daysBack = const Value.absent(),
    this.downloadFull = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncRulesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.clusterId = const Value.absent(),
    this.albumName = const Value.absent(),
    this.daysBack = const Value.absent(),
    this.downloadFull = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required DateTime createdAt,
  }) : type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<SyncRule> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? clusterId,
    Expression<String>? albumName,
    Expression<int>? daysBack,
    Expression<bool>? downloadFull,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (clusterId != null) 'cluster_id': clusterId,
      if (albumName != null) 'album_name': albumName,
      if (daysBack != null) 'days_back': daysBack,
      if (downloadFull != null) 'download_full': downloadFull,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String?>? clusterId,
    Value<String?>? albumName,
    Value<int?>? daysBack,
    Value<bool>? downloadFull,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime>? createdAt,
  }) {
    return SyncRulesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      clusterId: clusterId ?? this.clusterId,
      albumName: albumName ?? this.albumName,
      daysBack: daysBack ?? this.daysBack,
      downloadFull: downloadFull ?? this.downloadFull,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (clusterId.present) {
      map['cluster_id'] = Variable<String>(clusterId.value);
    }
    if (albumName.present) {
      map['album_name'] = Variable<String>(albumName.value);
    }
    if (daysBack.present) {
      map['days_back'] = Variable<int>(daysBack.value);
    }
    if (downloadFull.present) {
      map['download_full'] = Variable<bool>(downloadFull.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncRulesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('clusterId: $clusterId, ')
          ..write('albumName: $albumName, ')
          ..write('daysBack: $daysBack, ')
          ..write('downloadFull: $downloadFull, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncCacheEntriesTable extends SyncCacheEntries
    with TableInfo<$SyncCacheEntriesTable, SyncCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<int> fileId = GeneratedColumn<int>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sync_rules (id)',
    ),
  );
  static const VerificationMeta _downloadFullMeta = const VerificationMeta(
    'downloadFull',
  );
  @override
  late final GeneratedColumn<bool> downloadFull = GeneratedColumn<bool>(
    'download_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("download_full" IN (0, 1))',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
    'downloaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    fileId,
    ruleId,
    downloadFull,
    localPath,
    etag,
    downloadedAt,
    sizeBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('download_full')) {
      context.handle(
        _downloadFullMeta,
        downloadFull.isAcceptableOrUnknown(
          data['download_full']!,
          _downloadFullMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadFullMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    } else if (isInserting) {
      context.missing(_etagMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fileId, ruleId, downloadFull};
  @override
  SyncCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCacheEntry(
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rule_id'],
      )!,
      downloadFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}download_full'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}downloaded_at'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
    );
  }

  @override
  $SyncCacheEntriesTable createAlias(String alias) {
    return $SyncCacheEntriesTable(attachedDatabase, alias);
  }
}

class SyncCacheEntry extends DataClass implements Insertable<SyncCacheEntry> {
  final int fileId;
  final int ruleId;
  final bool downloadFull;
  final String localPath;
  final String etag;
  final DateTime downloadedAt;
  final int sizeBytes;
  const SyncCacheEntry({
    required this.fileId,
    required this.ruleId,
    required this.downloadFull,
    required this.localPath,
    required this.etag,
    required this.downloadedAt,
    required this.sizeBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file_id'] = Variable<int>(fileId);
    map['rule_id'] = Variable<int>(ruleId);
    map['download_full'] = Variable<bool>(downloadFull);
    map['local_path'] = Variable<String>(localPath);
    map['etag'] = Variable<String>(etag);
    map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    map['size_bytes'] = Variable<int>(sizeBytes);
    return map;
  }

  SyncCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return SyncCacheEntriesCompanion(
      fileId: Value(fileId),
      ruleId: Value(ruleId),
      downloadFull: Value(downloadFull),
      localPath: Value(localPath),
      etag: Value(etag),
      downloadedAt: Value(downloadedAt),
      sizeBytes: Value(sizeBytes),
    );
  }

  factory SyncCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCacheEntry(
      fileId: serializer.fromJson<int>(json['fileId']),
      ruleId: serializer.fromJson<int>(json['ruleId']),
      downloadFull: serializer.fromJson<bool>(json['downloadFull']),
      localPath: serializer.fromJson<String>(json['localPath']),
      etag: serializer.fromJson<String>(json['etag']),
      downloadedAt: serializer.fromJson<DateTime>(json['downloadedAt']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fileId': serializer.toJson<int>(fileId),
      'ruleId': serializer.toJson<int>(ruleId),
      'downloadFull': serializer.toJson<bool>(downloadFull),
      'localPath': serializer.toJson<String>(localPath),
      'etag': serializer.toJson<String>(etag),
      'downloadedAt': serializer.toJson<DateTime>(downloadedAt),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
    };
  }

  SyncCacheEntry copyWith({
    int? fileId,
    int? ruleId,
    bool? downloadFull,
    String? localPath,
    String? etag,
    DateTime? downloadedAt,
    int? sizeBytes,
  }) => SyncCacheEntry(
    fileId: fileId ?? this.fileId,
    ruleId: ruleId ?? this.ruleId,
    downloadFull: downloadFull ?? this.downloadFull,
    localPath: localPath ?? this.localPath,
    etag: etag ?? this.etag,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    sizeBytes: sizeBytes ?? this.sizeBytes,
  );
  SyncCacheEntry copyWithCompanion(SyncCacheEntriesCompanion data) {
    return SyncCacheEntry(
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      downloadFull: data.downloadFull.present
          ? data.downloadFull.value
          : this.downloadFull,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      etag: data.etag.present ? data.etag.value : this.etag,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCacheEntry(')
          ..write('fileId: $fileId, ')
          ..write('ruleId: $ruleId, ')
          ..write('downloadFull: $downloadFull, ')
          ..write('localPath: $localPath, ')
          ..write('etag: $etag, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('sizeBytes: $sizeBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    fileId,
    ruleId,
    downloadFull,
    localPath,
    etag,
    downloadedAt,
    sizeBytes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCacheEntry &&
          other.fileId == this.fileId &&
          other.ruleId == this.ruleId &&
          other.downloadFull == this.downloadFull &&
          other.localPath == this.localPath &&
          other.etag == this.etag &&
          other.downloadedAt == this.downloadedAt &&
          other.sizeBytes == this.sizeBytes);
}

class SyncCacheEntriesCompanion extends UpdateCompanion<SyncCacheEntry> {
  final Value<int> fileId;
  final Value<int> ruleId;
  final Value<bool> downloadFull;
  final Value<String> localPath;
  final Value<String> etag;
  final Value<DateTime> downloadedAt;
  final Value<int> sizeBytes;
  final Value<int> rowid;
  const SyncCacheEntriesCompanion({
    this.fileId = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.downloadFull = const Value.absent(),
    this.localPath = const Value.absent(),
    this.etag = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCacheEntriesCompanion.insert({
    required int fileId,
    required int ruleId,
    required bool downloadFull,
    required String localPath,
    required String etag,
    required DateTime downloadedAt,
    required int sizeBytes,
    this.rowid = const Value.absent(),
  }) : fileId = Value(fileId),
       ruleId = Value(ruleId),
       downloadFull = Value(downloadFull),
       localPath = Value(localPath),
       etag = Value(etag),
       downloadedAt = Value(downloadedAt),
       sizeBytes = Value(sizeBytes);
  static Insertable<SyncCacheEntry> custom({
    Expression<int>? fileId,
    Expression<int>? ruleId,
    Expression<bool>? downloadFull,
    Expression<String>? localPath,
    Expression<String>? etag,
    Expression<DateTime>? downloadedAt,
    Expression<int>? sizeBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fileId != null) 'file_id': fileId,
      if (ruleId != null) 'rule_id': ruleId,
      if (downloadFull != null) 'download_full': downloadFull,
      if (localPath != null) 'local_path': localPath,
      if (etag != null) 'etag': etag,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCacheEntriesCompanion copyWith({
    Value<int>? fileId,
    Value<int>? ruleId,
    Value<bool>? downloadFull,
    Value<String>? localPath,
    Value<String>? etag,
    Value<DateTime>? downloadedAt,
    Value<int>? sizeBytes,
    Value<int>? rowid,
  }) {
    return SyncCacheEntriesCompanion(
      fileId: fileId ?? this.fileId,
      ruleId: ruleId ?? this.ruleId,
      downloadFull: downloadFull ?? this.downloadFull,
      localPath: localPath ?? this.localPath,
      etag: etag ?? this.etag,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fileId.present) {
      map['file_id'] = Variable<int>(fileId.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (downloadFull.present) {
      map['download_full'] = Variable<bool>(downloadFull.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCacheEntriesCompanion(')
          ..write('fileId: $fileId, ')
          ..write('ruleId: $ruleId, ')
          ..write('downloadFull: $downloadFull, ')
          ..write('localPath: $localPath, ')
          ..write('etag: $etag, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncRulesTable syncRules = $SyncRulesTable(this);
  late final $SyncCacheEntriesTable syncCacheEntries = $SyncCacheEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncRules,
    syncCacheEntries,
  ];
}

typedef $$SyncRulesTableCreateCompanionBuilder =
    SyncRulesCompanion Function({
      Value<int> id,
      required String type,
      Value<String?> clusterId,
      Value<String?> albumName,
      Value<int?> daysBack,
      Value<bool> downloadFull,
      Value<DateTime?> lastSyncedAt,
      required DateTime createdAt,
    });
typedef $$SyncRulesTableUpdateCompanionBuilder =
    SyncRulesCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String?> clusterId,
      Value<String?> albumName,
      Value<int?> daysBack,
      Value<bool> downloadFull,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime> createdAt,
    });

final class $$SyncRulesTableReferences
    extends BaseReferences<_$AppDatabase, $SyncRulesTable, SyncRule> {
  $$SyncRulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SyncCacheEntriesTable, List<SyncCacheEntry>>
  _syncCacheEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncCacheEntries,
    aliasName: $_aliasNameGenerator(
      db.syncRules.id,
      db.syncCacheEntries.ruleId,
    ),
  );

  $$SyncCacheEntriesTableProcessedTableManager get syncCacheEntriesRefs {
    final manager = $$SyncCacheEntriesTableTableManager(
      $_db,
      $_db.syncCacheEntries,
    ).filter((f) => f.ruleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _syncCacheEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SyncRulesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncRulesTable> {
  $$SyncRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clusterId => $composableBuilder(
    column: $table.clusterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumName => $composableBuilder(
    column: $table.albumName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysBack => $composableBuilder(
    column: $table.daysBack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get downloadFull => $composableBuilder(
    column: $table.downloadFull,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> syncCacheEntriesRefs(
    Expression<bool> Function($$SyncCacheEntriesTableFilterComposer f) f,
  ) {
    final $$SyncCacheEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncCacheEntries,
      getReferencedColumn: (t) => t.ruleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncCacheEntriesTableFilterComposer(
            $db: $db,
            $table: $db.syncCacheEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SyncRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncRulesTable> {
  $$SyncRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clusterId => $composableBuilder(
    column: $table.clusterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumName => $composableBuilder(
    column: $table.albumName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysBack => $composableBuilder(
    column: $table.daysBack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get downloadFull => $composableBuilder(
    column: $table.downloadFull,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncRulesTable> {
  $$SyncRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get clusterId =>
      $composableBuilder(column: $table.clusterId, builder: (column) => column);

  GeneratedColumn<String> get albumName =>
      $composableBuilder(column: $table.albumName, builder: (column) => column);

  GeneratedColumn<int> get daysBack =>
      $composableBuilder(column: $table.daysBack, builder: (column) => column);

  GeneratedColumn<bool> get downloadFull => $composableBuilder(
    column: $table.downloadFull,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> syncCacheEntriesRefs<T extends Object>(
    Expression<T> Function($$SyncCacheEntriesTableAnnotationComposer a) f,
  ) {
    final $$SyncCacheEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncCacheEntries,
      getReferencedColumn: (t) => t.ruleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncCacheEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.syncCacheEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SyncRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncRulesTable,
          SyncRule,
          $$SyncRulesTableFilterComposer,
          $$SyncRulesTableOrderingComposer,
          $$SyncRulesTableAnnotationComposer,
          $$SyncRulesTableCreateCompanionBuilder,
          $$SyncRulesTableUpdateCompanionBuilder,
          (SyncRule, $$SyncRulesTableReferences),
          SyncRule,
          PrefetchHooks Function({bool syncCacheEntriesRefs})
        > {
  $$SyncRulesTableTableManager(_$AppDatabase db, $SyncRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> clusterId = const Value.absent(),
                Value<String?> albumName = const Value.absent(),
                Value<int?> daysBack = const Value.absent(),
                Value<bool> downloadFull = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncRulesCompanion(
                id: id,
                type: type,
                clusterId: clusterId,
                albumName: albumName,
                daysBack: daysBack,
                downloadFull: downloadFull,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<String?> clusterId = const Value.absent(),
                Value<String?> albumName = const Value.absent(),
                Value<int?> daysBack = const Value.absent(),
                Value<bool> downloadFull = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                required DateTime createdAt,
              }) => SyncRulesCompanion.insert(
                id: id,
                type: type,
                clusterId: clusterId,
                albumName: albumName,
                daysBack: daysBack,
                downloadFull: downloadFull,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({syncCacheEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (syncCacheEntriesRefs) db.syncCacheEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (syncCacheEntriesRefs)
                    await $_getPrefetchedData<
                      SyncRule,
                      $SyncRulesTable,
                      SyncCacheEntry
                    >(
                      currentTable: table,
                      referencedTable: $$SyncRulesTableReferences
                          ._syncCacheEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SyncRulesTableReferences(
                            db,
                            table,
                            p0,
                          ).syncCacheEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ruleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SyncRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncRulesTable,
      SyncRule,
      $$SyncRulesTableFilterComposer,
      $$SyncRulesTableOrderingComposer,
      $$SyncRulesTableAnnotationComposer,
      $$SyncRulesTableCreateCompanionBuilder,
      $$SyncRulesTableUpdateCompanionBuilder,
      (SyncRule, $$SyncRulesTableReferences),
      SyncRule,
      PrefetchHooks Function({bool syncCacheEntriesRefs})
    >;
typedef $$SyncCacheEntriesTableCreateCompanionBuilder =
    SyncCacheEntriesCompanion Function({
      required int fileId,
      required int ruleId,
      required bool downloadFull,
      required String localPath,
      required String etag,
      required DateTime downloadedAt,
      required int sizeBytes,
      Value<int> rowid,
    });
typedef $$SyncCacheEntriesTableUpdateCompanionBuilder =
    SyncCacheEntriesCompanion Function({
      Value<int> fileId,
      Value<int> ruleId,
      Value<bool> downloadFull,
      Value<String> localPath,
      Value<String> etag,
      Value<DateTime> downloadedAt,
      Value<int> sizeBytes,
      Value<int> rowid,
    });

final class $$SyncCacheEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SyncCacheEntriesTable, SyncCacheEntry> {
  $$SyncCacheEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SyncRulesTable _ruleIdTable(_$AppDatabase db) =>
      db.syncRules.createAlias(
        $_aliasNameGenerator(db.syncCacheEntries.ruleId, db.syncRules.id),
      );

  $$SyncRulesTableProcessedTableManager get ruleId {
    final $_column = $_itemColumn<int>('rule_id')!;

    final manager = $$SyncRulesTableTableManager(
      $_db,
      $_db.syncRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCacheEntriesTable> {
  $$SyncCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get downloadFull => $composableBuilder(
    column: $table.downloadFull,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  $$SyncRulesTableFilterComposer get ruleId {
    final $$SyncRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.syncRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncRulesTableFilterComposer(
            $db: $db,
            $table: $db.syncRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCacheEntriesTable> {
  $$SyncCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get downloadFull => $composableBuilder(
    column: $table.downloadFull,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SyncRulesTableOrderingComposer get ruleId {
    final $$SyncRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.syncRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncRulesTableOrderingComposer(
            $db: $db,
            $table: $db.syncRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCacheEntriesTable> {
  $$SyncCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<bool> get downloadFull => $composableBuilder(
    column: $table.downloadFull,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  $$SyncRulesTableAnnotationComposer get ruleId {
    final $$SyncRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.syncRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.syncRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCacheEntriesTable,
          SyncCacheEntry,
          $$SyncCacheEntriesTableFilterComposer,
          $$SyncCacheEntriesTableOrderingComposer,
          $$SyncCacheEntriesTableAnnotationComposer,
          $$SyncCacheEntriesTableCreateCompanionBuilder,
          $$SyncCacheEntriesTableUpdateCompanionBuilder,
          (SyncCacheEntry, $$SyncCacheEntriesTableReferences),
          SyncCacheEntry,
          PrefetchHooks Function({bool ruleId})
        > {
  $$SyncCacheEntriesTableTableManager(
    _$AppDatabase db,
    $SyncCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> fileId = const Value.absent(),
                Value<int> ruleId = const Value.absent(),
                Value<bool> downloadFull = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> etag = const Value.absent(),
                Value<DateTime> downloadedAt = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCacheEntriesCompanion(
                fileId: fileId,
                ruleId: ruleId,
                downloadFull: downloadFull,
                localPath: localPath,
                etag: etag,
                downloadedAt: downloadedAt,
                sizeBytes: sizeBytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int fileId,
                required int ruleId,
                required bool downloadFull,
                required String localPath,
                required String etag,
                required DateTime downloadedAt,
                required int sizeBytes,
                Value<int> rowid = const Value.absent(),
              }) => SyncCacheEntriesCompanion.insert(
                fileId: fileId,
                ruleId: ruleId,
                downloadFull: downloadFull,
                localPath: localPath,
                etag: etag,
                downloadedAt: downloadedAt,
                sizeBytes: sizeBytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncCacheEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ruleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ruleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ruleId,
                                referencedTable:
                                    $$SyncCacheEntriesTableReferences
                                        ._ruleIdTable(db),
                                referencedColumn:
                                    $$SyncCacheEntriesTableReferences
                                        ._ruleIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCacheEntriesTable,
      SyncCacheEntry,
      $$SyncCacheEntriesTableFilterComposer,
      $$SyncCacheEntriesTableOrderingComposer,
      $$SyncCacheEntriesTableAnnotationComposer,
      $$SyncCacheEntriesTableCreateCompanionBuilder,
      $$SyncCacheEntriesTableUpdateCompanionBuilder,
      (SyncCacheEntry, $$SyncCacheEntriesTableReferences),
      SyncCacheEntry,
      PrefetchHooks Function({bool ruleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncRulesTableTableManager get syncRules =>
      $$SyncRulesTableTableManager(_db, _db.syncRules);
  $$SyncCacheEntriesTableTableManager get syncCacheEntries =>
      $$SyncCacheEntriesTableTableManager(_db, _db.syncCacheEntries);
}
