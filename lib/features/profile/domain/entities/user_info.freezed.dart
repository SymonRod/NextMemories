// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserInfo {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  QuotaInfo get quota => throw _privateConstructorUsedError;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call({String id, String displayName, String? email, QuotaInfo quota});

  $QuotaInfoCopyWith<$Res> get quota;
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? quota = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            quota: null == quota
                ? _value.quota
                : quota // ignore: cast_nullable_to_non_nullable
                      as QuotaInfo,
          )
          as $Val,
    );
  }

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuotaInfoCopyWith<$Res> get quota {
    return $QuotaInfoCopyWith<$Res>(_value.quota, (value) {
      return _then(_value.copyWith(quota: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
    _$UserInfoImpl value,
    $Res Function(_$UserInfoImpl) then,
  ) = __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String displayName, String? email, QuotaInfo quota});

  @override
  $QuotaInfoCopyWith<$Res> get quota;
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
    _$UserInfoImpl _value,
    $Res Function(_$UserInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? quota = null,
  }) {
    return _then(
      _$UserInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        quota: null == quota
            ? _value.quota
            : quota // ignore: cast_nullable_to_non_nullable
                  as QuotaInfo,
      ),
    );
  }
}

/// @nodoc

class _$UserInfoImpl extends _UserInfo {
  const _$UserInfoImpl({
    required this.id,
    required this.displayName,
    this.email,
    required this.quota,
  }) : super._();

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? email;
  @override
  final QuotaInfo quota;

  @override
  String toString() {
    return 'UserInfo(id: $id, displayName: $displayName, email: $email, quota: $quota)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.quota, quota) || other.quota == quota));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, email, quota);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);
}

abstract class _UserInfo extends UserInfo {
  const factory _UserInfo({
    required final String id,
    required final String displayName,
    final String? email,
    required final QuotaInfo quota,
  }) = _$UserInfoImpl;
  const _UserInfo._() : super._();

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get email;
  @override
  QuotaInfo get quota;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuotaInfo {
  int get used => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get relative => throw _privateConstructorUsedError;
  bool get unlimited => throw _privateConstructorUsedError;

  /// Create a copy of QuotaInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuotaInfoCopyWith<QuotaInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaInfoCopyWith<$Res> {
  factory $QuotaInfoCopyWith(QuotaInfo value, $Res Function(QuotaInfo) then) =
      _$QuotaInfoCopyWithImpl<$Res, QuotaInfo>;
  @useResult
  $Res call({int used, int total, double relative, bool unlimited});
}

/// @nodoc
class _$QuotaInfoCopyWithImpl<$Res, $Val extends QuotaInfo>
    implements $QuotaInfoCopyWith<$Res> {
  _$QuotaInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuotaInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? total = null,
    Object? relative = null,
    Object? unlimited = null,
  }) {
    return _then(
      _value.copyWith(
            used: null == used
                ? _value.used
                : used // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            relative: null == relative
                ? _value.relative
                : relative // ignore: cast_nullable_to_non_nullable
                      as double,
            unlimited: null == unlimited
                ? _value.unlimited
                : unlimited // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuotaInfoImplCopyWith<$Res>
    implements $QuotaInfoCopyWith<$Res> {
  factory _$$QuotaInfoImplCopyWith(
    _$QuotaInfoImpl value,
    $Res Function(_$QuotaInfoImpl) then,
  ) = __$$QuotaInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int used, int total, double relative, bool unlimited});
}

/// @nodoc
class __$$QuotaInfoImplCopyWithImpl<$Res>
    extends _$QuotaInfoCopyWithImpl<$Res, _$QuotaInfoImpl>
    implements _$$QuotaInfoImplCopyWith<$Res> {
  __$$QuotaInfoImplCopyWithImpl(
    _$QuotaInfoImpl _value,
    $Res Function(_$QuotaInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuotaInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? total = null,
    Object? relative = null,
    Object? unlimited = null,
  }) {
    return _then(
      _$QuotaInfoImpl(
        used: null == used
            ? _value.used
            : used // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        relative: null == relative
            ? _value.relative
            : relative // ignore: cast_nullable_to_non_nullable
                  as double,
        unlimited: null == unlimited
            ? _value.unlimited
            : unlimited // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$QuotaInfoImpl extends _QuotaInfo {
  const _$QuotaInfoImpl({
    required this.used,
    required this.total,
    required this.relative,
    required this.unlimited,
  }) : super._();

  @override
  final int used;
  @override
  final int total;
  @override
  final double relative;
  @override
  final bool unlimited;

  @override
  String toString() {
    return 'QuotaInfo(used: $used, total: $total, relative: $relative, unlimited: $unlimited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaInfoImpl &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.relative, relative) ||
                other.relative == relative) &&
            (identical(other.unlimited, unlimited) ||
                other.unlimited == unlimited));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, used, total, relative, unlimited);

  /// Create a copy of QuotaInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaInfoImplCopyWith<_$QuotaInfoImpl> get copyWith =>
      __$$QuotaInfoImplCopyWithImpl<_$QuotaInfoImpl>(this, _$identity);
}

abstract class _QuotaInfo extends QuotaInfo {
  const factory _QuotaInfo({
    required final int used,
    required final int total,
    required final double relative,
    required final bool unlimited,
  }) = _$QuotaInfoImpl;
  const _QuotaInfo._() : super._();

  @override
  int get used;
  @override
  int get total;
  @override
  double get relative;
  @override
  bool get unlimited;

  /// Create a copy of QuotaInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuotaInfoImplCopyWith<_$QuotaInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
