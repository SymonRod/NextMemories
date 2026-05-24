// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncRule {
  int get id => throw _privateConstructorUsedError;
  SyncRuleType get type => throw _privateConstructorUsedError;
  String? get clusterId => throw _privateConstructorUsedError;
  String? get albumName => throw _privateConstructorUsedError;
  int? get daysBack => throw _privateConstructorUsedError;
  bool get downloadFull => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of SyncRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncRuleCopyWith<SyncRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncRuleCopyWith<$Res> {
  factory $SyncRuleCopyWith(SyncRule value, $Res Function(SyncRule) then) =
      _$SyncRuleCopyWithImpl<$Res, SyncRule>;
  @useResult
  $Res call({
    int id,
    SyncRuleType type,
    String? clusterId,
    String? albumName,
    int? daysBack,
    bool downloadFull,
    DateTime? lastSyncedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SyncRuleCopyWithImpl<$Res, $Val extends SyncRule>
    implements $SyncRuleCopyWith<$Res> {
  _$SyncRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? clusterId = freezed,
    Object? albumName = freezed,
    Object? daysBack = freezed,
    Object? downloadFull = null,
    Object? lastSyncedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SyncRuleType,
            clusterId: freezed == clusterId
                ? _value.clusterId
                : clusterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            albumName: freezed == albumName
                ? _value.albumName
                : albumName // ignore: cast_nullable_to_non_nullable
                      as String?,
            daysBack: freezed == daysBack
                ? _value.daysBack
                : daysBack // ignore: cast_nullable_to_non_nullable
                      as int?,
            downloadFull: null == downloadFull
                ? _value.downloadFull
                : downloadFull // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastSyncedAt: freezed == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncRuleImplCopyWith<$Res>
    implements $SyncRuleCopyWith<$Res> {
  factory _$$SyncRuleImplCopyWith(
    _$SyncRuleImpl value,
    $Res Function(_$SyncRuleImpl) then,
  ) = __$$SyncRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    SyncRuleType type,
    String? clusterId,
    String? albumName,
    int? daysBack,
    bool downloadFull,
    DateTime? lastSyncedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SyncRuleImplCopyWithImpl<$Res>
    extends _$SyncRuleCopyWithImpl<$Res, _$SyncRuleImpl>
    implements _$$SyncRuleImplCopyWith<$Res> {
  __$$SyncRuleImplCopyWithImpl(
    _$SyncRuleImpl _value,
    $Res Function(_$SyncRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? clusterId = freezed,
    Object? albumName = freezed,
    Object? daysBack = freezed,
    Object? downloadFull = null,
    Object? lastSyncedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$SyncRuleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SyncRuleType,
        clusterId: freezed == clusterId
            ? _value.clusterId
            : clusterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        albumName: freezed == albumName
            ? _value.albumName
            : albumName // ignore: cast_nullable_to_non_nullable
                  as String?,
        daysBack: freezed == daysBack
            ? _value.daysBack
            : daysBack // ignore: cast_nullable_to_non_nullable
                  as int?,
        downloadFull: null == downloadFull
            ? _value.downloadFull
            : downloadFull // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSyncedAt: freezed == lastSyncedAt
            ? _value.lastSyncedAt
            : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$SyncRuleImpl implements _SyncRule {
  const _$SyncRuleImpl({
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
  final int id;
  @override
  final SyncRuleType type;
  @override
  final String? clusterId;
  @override
  final String? albumName;
  @override
  final int? daysBack;
  @override
  final bool downloadFull;
  @override
  final DateTime? lastSyncedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SyncRule(id: $id, type: $type, clusterId: $clusterId, albumName: $albumName, daysBack: $daysBack, downloadFull: $downloadFull, lastSyncedAt: $lastSyncedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.clusterId, clusterId) ||
                other.clusterId == clusterId) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName) &&
            (identical(other.daysBack, daysBack) ||
                other.daysBack == daysBack) &&
            (identical(other.downloadFull, downloadFull) ||
                other.downloadFull == downloadFull) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    clusterId,
    albumName,
    daysBack,
    downloadFull,
    lastSyncedAt,
    createdAt,
  );

  /// Create a copy of SyncRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncRuleImplCopyWith<_$SyncRuleImpl> get copyWith =>
      __$$SyncRuleImplCopyWithImpl<_$SyncRuleImpl>(this, _$identity);
}

abstract class _SyncRule implements SyncRule {
  const factory _SyncRule({
    required final int id,
    required final SyncRuleType type,
    final String? clusterId,
    final String? albumName,
    final int? daysBack,
    required final bool downloadFull,
    final DateTime? lastSyncedAt,
    required final DateTime createdAt,
  }) = _$SyncRuleImpl;

  @override
  int get id;
  @override
  SyncRuleType get type;
  @override
  String? get clusterId;
  @override
  String? get albumName;
  @override
  int? get daysBack;
  @override
  bool get downloadFull;
  @override
  DateTime? get lastSyncedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of SyncRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncRuleImplCopyWith<_$SyncRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
