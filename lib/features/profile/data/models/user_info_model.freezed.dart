// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return _UserInfoModel.fromJson(json);
}

/// @nodoc
mixin _$UserInfoModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'display-name')
  String get displayName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  QuotaInfoModel get quota => throw _privateConstructorUsedError;

  /// Serializes this UserInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoModelCopyWith<UserInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoModelCopyWith<$Res> {
  factory $UserInfoModelCopyWith(
    UserInfoModel value,
    $Res Function(UserInfoModel) then,
  ) = _$UserInfoModelCopyWithImpl<$Res, UserInfoModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'display-name') String displayName,
    String? email,
    QuotaInfoModel quota,
  });

  $QuotaInfoModelCopyWith<$Res> get quota;
}

/// @nodoc
class _$UserInfoModelCopyWithImpl<$Res, $Val extends UserInfoModel>
    implements $UserInfoModelCopyWith<$Res> {
  _$UserInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfoModel
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
                      as QuotaInfoModel,
          )
          as $Val,
    );
  }

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuotaInfoModelCopyWith<$Res> get quota {
    return $QuotaInfoModelCopyWith<$Res>(_value.quota, (value) {
      return _then(_value.copyWith(quota: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserInfoModelImplCopyWith<$Res>
    implements $UserInfoModelCopyWith<$Res> {
  factory _$$UserInfoModelImplCopyWith(
    _$UserInfoModelImpl value,
    $Res Function(_$UserInfoModelImpl) then,
  ) = __$$UserInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'display-name') String displayName,
    String? email,
    QuotaInfoModel quota,
  });

  @override
  $QuotaInfoModelCopyWith<$Res> get quota;
}

/// @nodoc
class __$$UserInfoModelImplCopyWithImpl<$Res>
    extends _$UserInfoModelCopyWithImpl<$Res, _$UserInfoModelImpl>
    implements _$$UserInfoModelImplCopyWith<$Res> {
  __$$UserInfoModelImplCopyWithImpl(
    _$UserInfoModelImpl _value,
    $Res Function(_$UserInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfoModel
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
      _$UserInfoModelImpl(
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
                  as QuotaInfoModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoModelImpl implements _UserInfoModel {
  const _$UserInfoModelImpl({
    required this.id,
    @JsonKey(name: 'display-name') required this.displayName,
    this.email,
    required this.quota,
  });

  factory _$UserInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'display-name')
  final String displayName;
  @override
  final String? email;
  @override
  final QuotaInfoModel quota;

  @override
  String toString() {
    return 'UserInfoModel(id: $id, displayName: $displayName, email: $email, quota: $quota)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.quota, quota) || other.quota == quota));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, email, quota);

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      __$$UserInfoModelImplCopyWithImpl<_$UserInfoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoModelImplToJson(this);
  }
}

abstract class _UserInfoModel implements UserInfoModel {
  const factory _UserInfoModel({
    required final String id,
    @JsonKey(name: 'display-name') required final String displayName,
    final String? email,
    required final QuotaInfoModel quota,
  }) = _$UserInfoModelImpl;

  factory _UserInfoModel.fromJson(Map<String, dynamic> json) =
      _$UserInfoModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'display-name')
  String get displayName;
  @override
  String? get email;
  @override
  QuotaInfoModel get quota;

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuotaInfoModel _$QuotaInfoModelFromJson(Map<String, dynamic> json) {
  return _QuotaInfoModel.fromJson(json);
}

/// @nodoc
mixin _$QuotaInfoModel {
  @JsonKey(fromJson: _parseInt)
  int get used => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get total => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get relative => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get quota => throw _privateConstructorUsedError;

  /// Serializes this QuotaInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuotaInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuotaInfoModelCopyWith<QuotaInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaInfoModelCopyWith<$Res> {
  factory $QuotaInfoModelCopyWith(
    QuotaInfoModel value,
    $Res Function(QuotaInfoModel) then,
  ) = _$QuotaInfoModelCopyWithImpl<$Res, QuotaInfoModel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseInt) int used,
    @JsonKey(fromJson: _parseInt) int total,
    @JsonKey(fromJson: _parseDouble) double relative,
    @JsonKey(fromJson: _parseInt) int quota,
  });
}

/// @nodoc
class _$QuotaInfoModelCopyWithImpl<$Res, $Val extends QuotaInfoModel>
    implements $QuotaInfoModelCopyWith<$Res> {
  _$QuotaInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuotaInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? total = null,
    Object? relative = null,
    Object? quota = null,
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
            quota: null == quota
                ? _value.quota
                : quota // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuotaInfoModelImplCopyWith<$Res>
    implements $QuotaInfoModelCopyWith<$Res> {
  factory _$$QuotaInfoModelImplCopyWith(
    _$QuotaInfoModelImpl value,
    $Res Function(_$QuotaInfoModelImpl) then,
  ) = __$$QuotaInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseInt) int used,
    @JsonKey(fromJson: _parseInt) int total,
    @JsonKey(fromJson: _parseDouble) double relative,
    @JsonKey(fromJson: _parseInt) int quota,
  });
}

/// @nodoc
class __$$QuotaInfoModelImplCopyWithImpl<$Res>
    extends _$QuotaInfoModelCopyWithImpl<$Res, _$QuotaInfoModelImpl>
    implements _$$QuotaInfoModelImplCopyWith<$Res> {
  __$$QuotaInfoModelImplCopyWithImpl(
    _$QuotaInfoModelImpl _value,
    $Res Function(_$QuotaInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuotaInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = null,
    Object? total = null,
    Object? relative = null,
    Object? quota = null,
  }) {
    return _then(
      _$QuotaInfoModelImpl(
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
        quota: null == quota
            ? _value.quota
            : quota // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotaInfoModelImpl implements _QuotaInfoModel {
  const _$QuotaInfoModelImpl({
    @JsonKey(fromJson: _parseInt) required this.used,
    @JsonKey(fromJson: _parseInt) required this.total,
    @JsonKey(fromJson: _parseDouble) required this.relative,
    @JsonKey(fromJson: _parseInt) required this.quota,
  });

  factory _$QuotaInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotaInfoModelImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int used;
  @override
  @JsonKey(fromJson: _parseInt)
  final int total;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double relative;
  @override
  @JsonKey(fromJson: _parseInt)
  final int quota;

  @override
  String toString() {
    return 'QuotaInfoModel(used: $used, total: $total, relative: $relative, quota: $quota)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaInfoModelImpl &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.relative, relative) ||
                other.relative == relative) &&
            (identical(other.quota, quota) || other.quota == quota));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, used, total, relative, quota);

  /// Create a copy of QuotaInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaInfoModelImplCopyWith<_$QuotaInfoModelImpl> get copyWith =>
      __$$QuotaInfoModelImplCopyWithImpl<_$QuotaInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotaInfoModelImplToJson(this);
  }
}

abstract class _QuotaInfoModel implements QuotaInfoModel {
  const factory _QuotaInfoModel({
    @JsonKey(fromJson: _parseInt) required final int used,
    @JsonKey(fromJson: _parseInt) required final int total,
    @JsonKey(fromJson: _parseDouble) required final double relative,
    @JsonKey(fromJson: _parseInt) required final int quota,
  }) = _$QuotaInfoModelImpl;

  factory _QuotaInfoModel.fromJson(Map<String, dynamic> json) =
      _$QuotaInfoModelImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get used;
  @override
  @JsonKey(fromJson: _parseInt)
  int get total;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get relative;
  @override
  @JsonKey(fromJson: _parseInt)
  int get quota;

  /// Create a copy of QuotaInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuotaInfoModelImplCopyWith<_$QuotaInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
