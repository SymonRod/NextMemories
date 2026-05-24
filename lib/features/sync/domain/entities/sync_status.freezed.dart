// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncProgress {
  SyncStatus get status => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get downloaded => throw _privateConstructorUsedError;
  int get failed => throw _privateConstructorUsedError;
  String? get currentFile => throw _privateConstructorUsedError;

  /// Create a copy of SyncProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncProgressCopyWith<SyncProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncProgressCopyWith<$Res> {
  factory $SyncProgressCopyWith(
    SyncProgress value,
    $Res Function(SyncProgress) then,
  ) = _$SyncProgressCopyWithImpl<$Res, SyncProgress>;
  @useResult
  $Res call({
    SyncStatus status,
    int total,
    int downloaded,
    int failed,
    String? currentFile,
  });
}

/// @nodoc
class _$SyncProgressCopyWithImpl<$Res, $Val extends SyncProgress>
    implements $SyncProgressCopyWith<$Res> {
  _$SyncProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? total = null,
    Object? downloaded = null,
    Object? failed = null,
    Object? currentFile = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SyncStatus,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            downloaded: null == downloaded
                ? _value.downloaded
                : downloaded // ignore: cast_nullable_to_non_nullable
                      as int,
            failed: null == failed
                ? _value.failed
                : failed // ignore: cast_nullable_to_non_nullable
                      as int,
            currentFile: freezed == currentFile
                ? _value.currentFile
                : currentFile // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncProgressImplCopyWith<$Res>
    implements $SyncProgressCopyWith<$Res> {
  factory _$$SyncProgressImplCopyWith(
    _$SyncProgressImpl value,
    $Res Function(_$SyncProgressImpl) then,
  ) = __$$SyncProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SyncStatus status,
    int total,
    int downloaded,
    int failed,
    String? currentFile,
  });
}

/// @nodoc
class __$$SyncProgressImplCopyWithImpl<$Res>
    extends _$SyncProgressCopyWithImpl<$Res, _$SyncProgressImpl>
    implements _$$SyncProgressImplCopyWith<$Res> {
  __$$SyncProgressImplCopyWithImpl(
    _$SyncProgressImpl _value,
    $Res Function(_$SyncProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? total = null,
    Object? downloaded = null,
    Object? failed = null,
    Object? currentFile = freezed,
  }) {
    return _then(
      _$SyncProgressImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SyncStatus,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        downloaded: null == downloaded
            ? _value.downloaded
            : downloaded // ignore: cast_nullable_to_non_nullable
                  as int,
        failed: null == failed
            ? _value.failed
            : failed // ignore: cast_nullable_to_non_nullable
                  as int,
        currentFile: freezed == currentFile
            ? _value.currentFile
            : currentFile // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SyncProgressImpl implements _SyncProgress {
  const _$SyncProgressImpl({
    required this.status,
    required this.total,
    required this.downloaded,
    required this.failed,
    this.currentFile,
  });

  @override
  final SyncStatus status;
  @override
  final int total;
  @override
  final int downloaded;
  @override
  final int failed;
  @override
  final String? currentFile;

  @override
  String toString() {
    return 'SyncProgress(status: $status, total: $total, downloaded: $downloaded, failed: $failed, currentFile: $currentFile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncProgressImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.downloaded, downloaded) ||
                other.downloaded == downloaded) &&
            (identical(other.failed, failed) || other.failed == failed) &&
            (identical(other.currentFile, currentFile) ||
                other.currentFile == currentFile));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, total, downloaded, failed, currentFile);

  /// Create a copy of SyncProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncProgressImplCopyWith<_$SyncProgressImpl> get copyWith =>
      __$$SyncProgressImplCopyWithImpl<_$SyncProgressImpl>(this, _$identity);
}

abstract class _SyncProgress implements SyncProgress {
  const factory _SyncProgress({
    required final SyncStatus status,
    required final int total,
    required final int downloaded,
    required final int failed,
    final String? currentFile,
  }) = _$SyncProgressImpl;

  @override
  SyncStatus get status;
  @override
  int get total;
  @override
  int get downloaded;
  @override
  int get failed;
  @override
  String? get currentFile;

  /// Create a copy of SyncProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncProgressImplCopyWith<_$SyncProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
