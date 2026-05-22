// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Album {
  String get clusterId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int get lastAddedPhoto => throw _privateConstructorUsedError;
  String? get lastAddedPhotoEtag => throw _privateConstructorUsedError;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumCopyWith<Album> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumCopyWith<$Res> {
  factory $AlbumCopyWith(Album value, $Res Function(Album) then) =
      _$AlbumCopyWithImpl<$Res, Album>;
  @useResult
  $Res call({
    String clusterId,
    String name,
    int count,
    int lastAddedPhoto,
    String? lastAddedPhotoEtag,
  });
}

/// @nodoc
class _$AlbumCopyWithImpl<$Res, $Val extends Album>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Album
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
abstract class _$$AlbumImplCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$$AlbumImplCopyWith(
    _$AlbumImpl value,
    $Res Function(_$AlbumImpl) then,
  ) = __$$AlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String clusterId,
    String name,
    int count,
    int lastAddedPhoto,
    String? lastAddedPhotoEtag,
  });
}

/// @nodoc
class __$$AlbumImplCopyWithImpl<$Res>
    extends _$AlbumCopyWithImpl<$Res, _$AlbumImpl>
    implements _$$AlbumImplCopyWith<$Res> {
  __$$AlbumImplCopyWithImpl(
    _$AlbumImpl _value,
    $Res Function(_$AlbumImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Album
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
      _$AlbumImpl(
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

class _$AlbumImpl implements _Album {
  const _$AlbumImpl({
    required this.clusterId,
    required this.name,
    required this.count,
    required this.lastAddedPhoto,
    this.lastAddedPhotoEtag,
  });

  @override
  final String clusterId;
  @override
  final String name;
  @override
  final int count;
  @override
  final int lastAddedPhoto;
  @override
  final String? lastAddedPhotoEtag;

  @override
  String toString() {
    return 'Album(clusterId: $clusterId, name: $name, count: $count, lastAddedPhoto: $lastAddedPhoto, lastAddedPhotoEtag: $lastAddedPhotoEtag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumImpl &&
            (identical(other.clusterId, clusterId) ||
                other.clusterId == clusterId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.lastAddedPhoto, lastAddedPhoto) ||
                other.lastAddedPhoto == lastAddedPhoto) &&
            (identical(other.lastAddedPhotoEtag, lastAddedPhotoEtag) ||
                other.lastAddedPhotoEtag == lastAddedPhotoEtag));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    clusterId,
    name,
    count,
    lastAddedPhoto,
    lastAddedPhotoEtag,
  );

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumImplCopyWith<_$AlbumImpl> get copyWith =>
      __$$AlbumImplCopyWithImpl<_$AlbumImpl>(this, _$identity);
}

abstract class _Album implements Album {
  const factory _Album({
    required final String clusterId,
    required final String name,
    required final int count,
    required final int lastAddedPhoto,
    final String? lastAddedPhotoEtag,
  }) = _$AlbumImpl;

  @override
  String get clusterId;
  @override
  String get name;
  @override
  int get count;
  @override
  int get lastAddedPhoto;
  @override
  String? get lastAddedPhotoEtag;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumImplCopyWith<_$AlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
