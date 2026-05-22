// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServerConfigModel _$ServerConfigModelFromJson(Map<String, dynamic> json) {
  return _ServerConfigModel.fromJson(json);
}

/// @nodoc
mixin _$ServerConfigModel {
  String get serverUrl => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get appPassword => throw _privateConstructorUsedError;
  String? get serverName => throw _privateConstructorUsedError;

  /// Serializes this ServerConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServerConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServerConfigModelCopyWith<ServerConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerConfigModelCopyWith<$Res> {
  factory $ServerConfigModelCopyWith(
    ServerConfigModel value,
    $Res Function(ServerConfigModel) then,
  ) = _$ServerConfigModelCopyWithImpl<$Res, ServerConfigModel>;
  @useResult
  $Res call({
    String serverUrl,
    String username,
    String appPassword,
    String? serverName,
  });
}

/// @nodoc
class _$ServerConfigModelCopyWithImpl<$Res, $Val extends ServerConfigModel>
    implements $ServerConfigModelCopyWith<$Res> {
  _$ServerConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverUrl = null,
    Object? username = null,
    Object? appPassword = null,
    Object? serverName = freezed,
  }) {
    return _then(
      _value.copyWith(
            serverUrl: null == serverUrl
                ? _value.serverUrl
                : serverUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            appPassword: null == appPassword
                ? _value.appPassword
                : appPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            serverName: freezed == serverName
                ? _value.serverName
                : serverName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServerConfigModelImplCopyWith<$Res>
    implements $ServerConfigModelCopyWith<$Res> {
  factory _$$ServerConfigModelImplCopyWith(
    _$ServerConfigModelImpl value,
    $Res Function(_$ServerConfigModelImpl) then,
  ) = __$$ServerConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String serverUrl,
    String username,
    String appPassword,
    String? serverName,
  });
}

/// @nodoc
class __$$ServerConfigModelImplCopyWithImpl<$Res>
    extends _$ServerConfigModelCopyWithImpl<$Res, _$ServerConfigModelImpl>
    implements _$$ServerConfigModelImplCopyWith<$Res> {
  __$$ServerConfigModelImplCopyWithImpl(
    _$ServerConfigModelImpl _value,
    $Res Function(_$ServerConfigModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverUrl = null,
    Object? username = null,
    Object? appPassword = null,
    Object? serverName = freezed,
  }) {
    return _then(
      _$ServerConfigModelImpl(
        serverUrl: null == serverUrl
            ? _value.serverUrl
            : serverUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        appPassword: null == appPassword
            ? _value.appPassword
            : appPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        serverName: freezed == serverName
            ? _value.serverName
            : serverName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerConfigModelImpl implements _ServerConfigModel {
  const _$ServerConfigModelImpl({
    required this.serverUrl,
    required this.username,
    required this.appPassword,
    this.serverName,
  });

  factory _$ServerConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerConfigModelImplFromJson(json);

  @override
  final String serverUrl;
  @override
  final String username;
  @override
  final String appPassword;
  @override
  final String? serverName;

  @override
  String toString() {
    return 'ServerConfigModel(serverUrl: $serverUrl, username: $username, appPassword: $appPassword, serverName: $serverName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerConfigModelImpl &&
            (identical(other.serverUrl, serverUrl) ||
                other.serverUrl == serverUrl) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.appPassword, appPassword) ||
                other.appPassword == appPassword) &&
            (identical(other.serverName, serverName) ||
                other.serverName == serverName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, serverUrl, username, appPassword, serverName);

  /// Create a copy of ServerConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerConfigModelImplCopyWith<_$ServerConfigModelImpl> get copyWith =>
      __$$ServerConfigModelImplCopyWithImpl<_$ServerConfigModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerConfigModelImplToJson(this);
  }
}

abstract class _ServerConfigModel implements ServerConfigModel {
  const factory _ServerConfigModel({
    required final String serverUrl,
    required final String username,
    required final String appPassword,
    final String? serverName,
  }) = _$ServerConfigModelImpl;

  factory _ServerConfigModel.fromJson(Map<String, dynamic> json) =
      _$ServerConfigModelImpl.fromJson;

  @override
  String get serverUrl;
  @override
  String get username;
  @override
  String get appPassword;
  @override
  String? get serverName;

  /// Create a copy of ServerConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerConfigModelImplCopyWith<_$ServerConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
