// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) {
  return _PhotoModel.fromJson(json);
}

/// @nodoc
mixin _$PhotoModel {
  @JsonKey(name: 'fileid')
  int get fileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dayid')
  int get dayId => throw _privateConstructorUsedError;
  String get basename => throw _privateConstructorUsedError;
  int get epoch => throw _privateConstructorUsedError;
  String get mimetype => throw _privateConstructorUsedError;
  @JsonKey(name: 'w')
  int? get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'h')
  int? get height => throw _privateConstructorUsedError;
  String? get etag => throw _privateConstructorUsedError;
  String? get auid => throw _privateConstructorUsedError;
  @JsonKey(name: 'isvideo')
  int? get isVideoRaw => throw _privateConstructorUsedError;
  @JsonKey(name: 'isfavorite')
  int? get isFavoriteRaw => throw _privateConstructorUsedError;

  /// Serializes this PhotoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoModelCopyWith<PhotoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoModelCopyWith<$Res> {
  factory $PhotoModelCopyWith(
    PhotoModel value,
    $Res Function(PhotoModel) then,
  ) = _$PhotoModelCopyWithImpl<$Res, PhotoModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'fileid') int fileId,
    @JsonKey(name: 'dayid') int dayId,
    String basename,
    int epoch,
    String mimetype,
    @JsonKey(name: 'w') int? width,
    @JsonKey(name: 'h') int? height,
    String? etag,
    String? auid,
    @JsonKey(name: 'isvideo') int? isVideoRaw,
    @JsonKey(name: 'isfavorite') int? isFavoriteRaw,
  });
}

/// @nodoc
class _$PhotoModelCopyWithImpl<$Res, $Val extends PhotoModel>
    implements $PhotoModelCopyWith<$Res> {
  _$PhotoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoModel
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
    Object? isVideoRaw = freezed,
    Object? isFavoriteRaw = freezed,
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
            isVideoRaw: freezed == isVideoRaw
                ? _value.isVideoRaw
                : isVideoRaw // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFavoriteRaw: freezed == isFavoriteRaw
                ? _value.isFavoriteRaw
                : isFavoriteRaw // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhotoModelImplCopyWith<$Res>
    implements $PhotoModelCopyWith<$Res> {
  factory _$$PhotoModelImplCopyWith(
    _$PhotoModelImpl value,
    $Res Function(_$PhotoModelImpl) then,
  ) = __$$PhotoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'fileid') int fileId,
    @JsonKey(name: 'dayid') int dayId,
    String basename,
    int epoch,
    String mimetype,
    @JsonKey(name: 'w') int? width,
    @JsonKey(name: 'h') int? height,
    String? etag,
    String? auid,
    @JsonKey(name: 'isvideo') int? isVideoRaw,
    @JsonKey(name: 'isfavorite') int? isFavoriteRaw,
  });
}

/// @nodoc
class __$$PhotoModelImplCopyWithImpl<$Res>
    extends _$PhotoModelCopyWithImpl<$Res, _$PhotoModelImpl>
    implements _$$PhotoModelImplCopyWith<$Res> {
  __$$PhotoModelImplCopyWithImpl(
    _$PhotoModelImpl _value,
    $Res Function(_$PhotoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoModel
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
    Object? isVideoRaw = freezed,
    Object? isFavoriteRaw = freezed,
  }) {
    return _then(
      _$PhotoModelImpl(
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
        isVideoRaw: freezed == isVideoRaw
            ? _value.isVideoRaw
            : isVideoRaw // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFavoriteRaw: freezed == isFavoriteRaw
            ? _value.isFavoriteRaw
            : isFavoriteRaw // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoModelImpl implements _PhotoModel {
  const _$PhotoModelImpl({
    @JsonKey(name: 'fileid') required this.fileId,
    @JsonKey(name: 'dayid') required this.dayId,
    required this.basename,
    required this.epoch,
    required this.mimetype,
    @JsonKey(name: 'w') this.width,
    @JsonKey(name: 'h') this.height,
    this.etag,
    this.auid,
    @JsonKey(name: 'isvideo') this.isVideoRaw,
    @JsonKey(name: 'isfavorite') this.isFavoriteRaw,
  });

  factory _$PhotoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoModelImplFromJson(json);

  @override
  @JsonKey(name: 'fileid')
  final int fileId;
  @override
  @JsonKey(name: 'dayid')
  final int dayId;
  @override
  final String basename;
  @override
  final int epoch;
  @override
  final String mimetype;
  @override
  @JsonKey(name: 'w')
  final int? width;
  @override
  @JsonKey(name: 'h')
  final int? height;
  @override
  final String? etag;
  @override
  final String? auid;
  @override
  @JsonKey(name: 'isvideo')
  final int? isVideoRaw;
  @override
  @JsonKey(name: 'isfavorite')
  final int? isFavoriteRaw;

  @override
  String toString() {
    return 'PhotoModel(fileId: $fileId, dayId: $dayId, basename: $basename, epoch: $epoch, mimetype: $mimetype, width: $width, height: $height, etag: $etag, auid: $auid, isVideoRaw: $isVideoRaw, isFavoriteRaw: $isFavoriteRaw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoModelImpl &&
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
            (identical(other.isVideoRaw, isVideoRaw) ||
                other.isVideoRaw == isVideoRaw) &&
            (identical(other.isFavoriteRaw, isFavoriteRaw) ||
                other.isFavoriteRaw == isFavoriteRaw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    isVideoRaw,
    isFavoriteRaw,
  );

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoModelImplCopyWith<_$PhotoModelImpl> get copyWith =>
      __$$PhotoModelImplCopyWithImpl<_$PhotoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoModelImplToJson(this);
  }
}

abstract class _PhotoModel implements PhotoModel {
  const factory _PhotoModel({
    @JsonKey(name: 'fileid') required final int fileId,
    @JsonKey(name: 'dayid') required final int dayId,
    required final String basename,
    required final int epoch,
    required final String mimetype,
    @JsonKey(name: 'w') final int? width,
    @JsonKey(name: 'h') final int? height,
    final String? etag,
    final String? auid,
    @JsonKey(name: 'isvideo') final int? isVideoRaw,
    @JsonKey(name: 'isfavorite') final int? isFavoriteRaw,
  }) = _$PhotoModelImpl;

  factory _PhotoModel.fromJson(Map<String, dynamic> json) =
      _$PhotoModelImpl.fromJson;

  @override
  @JsonKey(name: 'fileid')
  int get fileId;
  @override
  @JsonKey(name: 'dayid')
  int get dayId;
  @override
  String get basename;
  @override
  int get epoch;
  @override
  String get mimetype;
  @override
  @JsonKey(name: 'w')
  int? get width;
  @override
  @JsonKey(name: 'h')
  int? get height;
  @override
  String? get etag;
  @override
  String? get auid;
  @override
  @JsonKey(name: 'isvideo')
  int? get isVideoRaw;
  @override
  @JsonKey(name: 'isfavorite')
  int? get isFavoriteRaw;

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoModelImplCopyWith<_$PhotoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
