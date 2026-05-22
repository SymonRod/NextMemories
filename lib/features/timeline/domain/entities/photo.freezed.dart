// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Photo {
  int get fileId => throw _privateConstructorUsedError;
  int get dayId => throw _privateConstructorUsedError;
  String get basename => throw _privateConstructorUsedError;
  int get epoch => throw _privateConstructorUsedError;
  String get mimetype => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  String? get etag => throw _privateConstructorUsedError;
  String? get auid => throw _privateConstructorUsedError;
  bool get isVideo => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoCopyWith<Photo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoCopyWith<$Res> {
  factory $PhotoCopyWith(Photo value, $Res Function(Photo) then) =
      _$PhotoCopyWithImpl<$Res, Photo>;
  @useResult
  $Res call({
    int fileId,
    int dayId,
    String basename,
    int epoch,
    String mimetype,
    int? width,
    int? height,
    String? etag,
    String? auid,
    bool isVideo,
    bool isFavorite,
  });
}

/// @nodoc
class _$PhotoCopyWithImpl<$Res, $Val extends Photo>
    implements $PhotoCopyWith<$Res> {
  _$PhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? dayId = null,
    Object? basename = null,
    Object? epoch = null,
    Object? mimetype = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? etag = freezed,
    Object? auid = freezed,
    Object? isVideo = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _value.copyWith(
            fileId: null == fileId
                ? _value.fileId
                : fileId // ignore: cast_nullable_to_non_nullable
                      as int,
            dayId: null == dayId
                ? _value.dayId
                : dayId // ignore: cast_nullable_to_non_nullable
                      as int,
            basename: null == basename
                ? _value.basename
                : basename // ignore: cast_nullable_to_non_nullable
                      as String,
            epoch: null == epoch
                ? _value.epoch
                : epoch // ignore: cast_nullable_to_non_nullable
                      as int,
            mimetype: null == mimetype
                ? _value.mimetype
                : mimetype // ignore: cast_nullable_to_non_nullable
                      as String,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            etag: freezed == etag
                ? _value.etag
                : etag // ignore: cast_nullable_to_non_nullable
                      as String?,
            auid: freezed == auid
                ? _value.auid
                : auid // ignore: cast_nullable_to_non_nullable
                      as String?,
            isVideo: null == isVideo
                ? _value.isVideo
                : isVideo // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhotoImplCopyWith<$Res> implements $PhotoCopyWith<$Res> {
  factory _$$PhotoImplCopyWith(
    _$PhotoImpl value,
    $Res Function(_$PhotoImpl) then,
  ) = __$$PhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int fileId,
    int dayId,
    String basename,
    int epoch,
    String mimetype,
    int? width,
    int? height,
    String? etag,
    String? auid,
    bool isVideo,
    bool isFavorite,
  });
}

/// @nodoc
class __$$PhotoImplCopyWithImpl<$Res>
    extends _$PhotoCopyWithImpl<$Res, _$PhotoImpl>
    implements _$$PhotoImplCopyWith<$Res> {
  __$$PhotoImplCopyWithImpl(
    _$PhotoImpl _value,
    $Res Function(_$PhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? dayId = null,
    Object? basename = null,
    Object? epoch = null,
    Object? mimetype = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? etag = freezed,
    Object? auid = freezed,
    Object? isVideo = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$PhotoImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as int,
        dayId: null == dayId
            ? _value.dayId
            : dayId // ignore: cast_nullable_to_non_nullable
                  as int,
        basename: null == basename
            ? _value.basename
            : basename // ignore: cast_nullable_to_non_nullable
                  as String,
        epoch: null == epoch
            ? _value.epoch
            : epoch // ignore: cast_nullable_to_non_nullable
                  as int,
        mimetype: null == mimetype
            ? _value.mimetype
            : mimetype // ignore: cast_nullable_to_non_nullable
                  as String,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        etag: freezed == etag
            ? _value.etag
            : etag // ignore: cast_nullable_to_non_nullable
                  as String?,
        auid: freezed == auid
            ? _value.auid
            : auid // ignore: cast_nullable_to_non_nullable
                  as String?,
        isVideo: null == isVideo
            ? _value.isVideo
            : isVideo // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PhotoImpl implements _Photo {
  const _$PhotoImpl({
    required this.fileId,
    required this.dayId,
    required this.basename,
    required this.epoch,
    required this.mimetype,
    this.width,
    this.height,
    this.etag,
    this.auid,
    this.isVideo = false,
    this.isFavorite = false,
  });

  @override
  final int fileId;
  @override
  final int dayId;
  @override
  final String basename;
  @override
  final int epoch;
  @override
  final String mimetype;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final String? etag;
  @override
  final String? auid;
  @override
  @JsonKey()
  final bool isVideo;
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'Photo(fileId: $fileId, dayId: $dayId, basename: $basename, epoch: $epoch, mimetype: $mimetype, width: $width, height: $height, etag: $etag, auid: $auid, isVideo: $isVideo, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.dayId, dayId) || other.dayId == dayId) &&
            (identical(other.basename, basename) ||
                other.basename == basename) &&
            (identical(other.epoch, epoch) || other.epoch == epoch) &&
            (identical(other.mimetype, mimetype) ||
                other.mimetype == mimetype) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.etag, etag) || other.etag == etag) &&
            (identical(other.auid, auid) || other.auid == auid) &&
            (identical(other.isVideo, isVideo) || other.isVideo == isVideo) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fileId,
    dayId,
    basename,
    epoch,
    mimetype,
    width,
    height,
    etag,
    auid,
    isVideo,
    isFavorite,
  );

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoImplCopyWith<_$PhotoImpl> get copyWith =>
      __$$PhotoImplCopyWithImpl<_$PhotoImpl>(this, _$identity);
}

abstract class _Photo implements Photo {
  const factory _Photo({
    required final int fileId,
    required final int dayId,
    required final String basename,
    required final int epoch,
    required final String mimetype,
    final int? width,
    final int? height,
    final String? etag,
    final String? auid,
    final bool isVideo,
    final bool isFavorite,
  }) = _$PhotoImpl;

  @override
  int get fileId;
  @override
  int get dayId;
  @override
  String get basename;
  @override
  int get epoch;
  @override
  String get mimetype;
  @override
  int? get width;
  @override
  int? get height;
  @override
  String? get etag;
  @override
  String? get auid;
  @override
  bool get isVideo;
  @override
  bool get isFavorite;

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoImplCopyWith<_$PhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
