// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_album_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WidgetAlbumConfig {
  int get ruleId => throw _privateConstructorUsedError;
  String get clusterId => throw _privateConstructorUsedError;
  String get albumName => throw _privateConstructorUsedError;

  /// Create a copy of WidgetAlbumConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WidgetAlbumConfigCopyWith<WidgetAlbumConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WidgetAlbumConfigCopyWith<$Res> {
  factory $WidgetAlbumConfigCopyWith(
    WidgetAlbumConfig value,
    $Res Function(WidgetAlbumConfig) then,
  ) = _$WidgetAlbumConfigCopyWithImpl<$Res, WidgetAlbumConfig>;
  @useResult
  $Res call({int ruleId, String clusterId, String albumName});
}

/// @nodoc
class _$WidgetAlbumConfigCopyWithImpl<$Res, $Val extends WidgetAlbumConfig>
    implements $WidgetAlbumConfigCopyWith<$Res> {
  _$WidgetAlbumConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WidgetAlbumConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ruleId = null,
    Object? clusterId = null,
    Object? albumName = null,
  }) {
    return _then(
      _value.copyWith(
            ruleId: null == ruleId
                ? _value.ruleId
                : ruleId // ignore: cast_nullable_to_non_nullable
                      as int,
            clusterId: null == clusterId
                ? _value.clusterId
                : clusterId // ignore: cast_nullable_to_non_nullable
                      as String,
            albumName: null == albumName
                ? _value.albumName
                : albumName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WidgetAlbumConfigImplCopyWith<$Res>
    implements $WidgetAlbumConfigCopyWith<$Res> {
  factory _$$WidgetAlbumConfigImplCopyWith(
    _$WidgetAlbumConfigImpl value,
    $Res Function(_$WidgetAlbumConfigImpl) then,
  ) = __$$WidgetAlbumConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int ruleId, String clusterId, String albumName});
}

/// @nodoc
class __$$WidgetAlbumConfigImplCopyWithImpl<$Res>
    extends _$WidgetAlbumConfigCopyWithImpl<$Res, _$WidgetAlbumConfigImpl>
    implements _$$WidgetAlbumConfigImplCopyWith<$Res> {
  __$$WidgetAlbumConfigImplCopyWithImpl(
    _$WidgetAlbumConfigImpl _value,
    $Res Function(_$WidgetAlbumConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WidgetAlbumConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ruleId = null,
    Object? clusterId = null,
    Object? albumName = null,
  }) {
    return _then(
      _$WidgetAlbumConfigImpl(
        ruleId: null == ruleId
            ? _value.ruleId
            : ruleId // ignore: cast_nullable_to_non_nullable
                  as int,
        clusterId: null == clusterId
            ? _value.clusterId
            : clusterId // ignore: cast_nullable_to_non_nullable
                  as String,
        albumName: null == albumName
            ? _value.albumName
            : albumName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WidgetAlbumConfigImpl implements _WidgetAlbumConfig {
  const _$WidgetAlbumConfigImpl({
    required this.ruleId,
    required this.clusterId,
    required this.albumName,
  });

  @override
  final int ruleId;
  @override
  final String clusterId;
  @override
  final String albumName;

  @override
  String toString() {
    return 'WidgetAlbumConfig(ruleId: $ruleId, clusterId: $clusterId, albumName: $albumName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetAlbumConfigImpl &&
            (identical(other.ruleId, ruleId) || other.ruleId == ruleId) &&
            (identical(other.clusterId, clusterId) ||
                other.clusterId == clusterId) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ruleId, clusterId, albumName);

  /// Create a copy of WidgetAlbumConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetAlbumConfigImplCopyWith<_$WidgetAlbumConfigImpl> get copyWith =>
      __$$WidgetAlbumConfigImplCopyWithImpl<_$WidgetAlbumConfigImpl>(
        this,
        _$identity,
      );
}

abstract class _WidgetAlbumConfig implements WidgetAlbumConfig {
  const factory _WidgetAlbumConfig({
    required final int ruleId,
    required final String clusterId,
    required final String albumName,
  }) = _$WidgetAlbumConfigImpl;

  @override
  int get ruleId;
  @override
  String get clusterId;
  @override
  String get albumName;

  /// Create a copy of WidgetAlbumConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WidgetAlbumConfigImplCopyWith<_$WidgetAlbumConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
