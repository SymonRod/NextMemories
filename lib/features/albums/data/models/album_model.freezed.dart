// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) {
  return _AlbumModel.fromJson(json);
}

/// @nodoc
mixin _$AlbumModel {
  @JsonKey(name: 'cluster_id')
  String get clusterId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_added_photo')
  int get lastAddedPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_added_photo_etag')
  String? get lastAddedPhotoEtag => throw _privateConstructorUsedError;

  /// Serializes this AlbumModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumModelCopyWith<AlbumModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumModelCopyWith<$Res> {
  factory $AlbumModelCopyWith(
    AlbumModel value,
    $Res Function(AlbumModel) then,
  ) = _$AlbumModelCopyWithImpl<$Res, AlbumModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'cluster_id') String clusterId,
    String name,
    int count,
    @JsonKey(name: 'last_added_photo') int lastAddedPhoto,
    @JsonKey(name: 'last_added_photo_etag') String? lastAddedPhotoEtag,
  });
}

/// @nodoc
class _$AlbumModelCopyWithImpl<$Res, $Val extends AlbumModel>
    implements $AlbumModelCopyWith<$Res> {
  _$AlbumModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clusterId = null,
    Object? name = null,
    Object? count = null,
    Object? lastAddedPhoto = null,
    Object? lastAddedPhotoEtag = freezed,
  }) {
    return _then(
      _value.copyWith(
            clusterId: null == clusterId
                ? _value.clusterId
                : clusterId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            lastAddedPhoto: null == lastAddedPhoto
                ? _value.lastAddedPhoto
                : lastAddedPhoto // ignore: cast_nullable_to_non_nullable
                      as int,
            lastAddedPhotoEtag: freezed == lastAddedPhotoEtag
                ? _value.lastAddedPhotoEtag
                : lastAddedPhotoEtag // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlbumModelImplCopyWith<$Res>
    implements $AlbumModelCopyWith<$Res> {
  factory _$$AlbumModelImplCopyWith(
    _$AlbumModelImpl value,
    $Res Function(_$AlbumModelImpl) then,
  ) = __$$AlbumModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'cluster_id') String clusterId,
    String name,
    int count,
    @JsonKey(name: 'last_added_photo') int lastAddedPhoto,
    @JsonKey(name: 'last_added_photo_etag') String? lastAddedPhotoEtag,
  });
}

/// @nodoc
class __$$AlbumModelImplCopyWithImpl<$Res>
    extends _$AlbumModelCopyWithImpl<$Res, _$AlbumModelImpl>
    implements _$$AlbumModelImplCopyWith<$Res> {
  __$$AlbumModelImplCopyWithImpl(
    _$AlbumModelImpl _value,
    $Res Function(_$AlbumModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clusterId = null,
    Object? name = null,
    Object? count = null,
    Object? lastAddedPhoto = null,
    Object? lastAddedPhotoEtag = freezed,
  }) {
    return _then(
      _$AlbumModelImpl(
        clusterId: null == clusterId
            ? _value.clusterId
            : clusterId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        lastAddedPhoto: null == lastAddedPhoto
            ? _value.lastAddedPhoto
            : lastAddedPhoto // ignore: cast_nullable_to_non_nullable
                  as int,
        lastAddedPhotoEtag: freezed == lastAddedPhotoEtag
            ? _value.lastAddedPhotoEtag
            : lastAddedPhotoEtag // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlbumModelImpl implements _AlbumModel {
  const _$AlbumModelImpl({
    @JsonKey(name: 'cluster_id') required this.clusterId,
    required this.name,
    required this.count,
    @JsonKey(name: 'last_added_photo') required this.lastAddedPhoto,
    @JsonKey(name: 'last_added_photo_etag') this.lastAddedPhotoEtag,
  });

  factory _$AlbumModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlbumModelImplFromJson(json);

  @override
  @JsonKey(name: 'cluster_id')
  final String clusterId;
  @override
  final String name;
  @override
  final int count;
  @override
  @JsonKey(name: 'last_added_photo')
  final int lastAddedPhoto;
  @override
  @JsonKey(name: 'last_added_photo_etag')
  final String? lastAddedPhotoEtag;

  @override
  String toString() {
    return 'AlbumModel(clusterId: $clusterId, name: $name, count: $count, lastAddedPhoto: $lastAddedPhoto, lastAddedPhotoEtag: $lastAddedPhotoEtag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumModelImpl &&
            (identical(other.clusterId, clusterId) ||
                other.clusterId == clusterId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.lastAddedPhoto, lastAddedPhoto) ||
                other.lastAddedPhoto == lastAddedPhoto) &&
            (identical(other.lastAddedPhotoEtag, lastAddedPhotoEtag) ||
                other.lastAddedPhotoEtag == lastAddedPhotoEtag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clusterId,
    name,
    count,
    lastAddedPhoto,
    lastAddedPhotoEtag,
  );

  /// Create a copy of AlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumModelImplCopyWith<_$AlbumModelImpl> get copyWith =>
      __$$AlbumModelImplCopyWithImpl<_$AlbumModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlbumModelImplToJson(this);
  }
}

abstract class _AlbumModel implements AlbumModel {
  const factory _AlbumModel({
    @JsonKey(name: 'cluster_id') required final String clusterId,
    required final String name,
    required final int count,
    @JsonKey(name: 'last_added_photo') required final int lastAddedPhoto,
    @JsonKey(name: 'last_added_photo_etag') final String? lastAddedPhotoEtag,
  }) = _$AlbumModelImpl;

  factory _AlbumModel.fromJson(Map<String, dynamic> json) =
      _$AlbumModelImpl.fromJson;

  @override
  @JsonKey(name: 'cluster_id')
  String get clusterId;
  @override
  String get name;
  @override
  int get count;
  @override
  @JsonKey(name: 'last_added_photo')
  int get lastAddedPhoto;
  @override
  @JsonKey(name: 'last_added_photo_etag')
  String? get lastAddedPhotoEtag;

  /// Create a copy of AlbumModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumModelImplCopyWith<_$AlbumModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
