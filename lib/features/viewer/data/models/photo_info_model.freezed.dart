// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhotoInfoModel _$PhotoInfoModelFromJson(Map<String, dynamic> json) {
  return _PhotoInfoModel.fromJson(json);
}

/// @nodoc
mixin _$PhotoInfoModel {
  int get fileid => throw _privateConstructorUsedError;
  String get basename => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'w')
  int? get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'h')
  int? get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'datetaken')
  int? get dateTaken => throw _privateConstructorUsedError;
  String? get filename => throw _privateConstructorUsedError;
  ExifModel? get exif => throw _privateConstructorUsedError;

  /// Serializes this PhotoInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoInfoModelCopyWith<PhotoInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoInfoModelCopyWith<$Res> {
  factory $PhotoInfoModelCopyWith(
    PhotoInfoModel value,
    $Res Function(PhotoInfoModel) then,
  ) = _$PhotoInfoModelCopyWithImpl<$Res, PhotoInfoModel>;
  @useResult
  $Res call({
    int fileid,
    String basename,
    int? size,
    @JsonKey(name: 'w') int? width,
    @JsonKey(name: 'h') int? height,
    @JsonKey(name: 'datetaken') int? dateTaken,
    String? filename,
    ExifModel? exif,
  });

  $ExifModelCopyWith<$Res>? get exif;
}

/// @nodoc
class _$PhotoInfoModelCopyWithImpl<$Res, $Val extends PhotoInfoModel>
    implements $PhotoInfoModelCopyWith<$Res> {
  _$PhotoInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileid = null,
    Object? basename = null,
    Object? size = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? dateTaken = freezed,
    Object? filename = freezed,
    Object? exif = freezed,
  }) {
    return _then(
      _value.copyWith(
            fileid: null == fileid
                ? _value.fileid
                : fileid // ignore: cast_nullable_to_non_nullable
                      as int,
            basename: null == basename
                ? _value.basename
                : basename // ignore: cast_nullable_to_non_nullable
                      as String,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            dateTaken: freezed == dateTaken
                ? _value.dateTaken
                : dateTaken // ignore: cast_nullable_to_non_nullable
                      as int?,
            filename: freezed == filename
                ? _value.filename
                : filename // ignore: cast_nullable_to_non_nullable
                      as String?,
            exif: freezed == exif
                ? _value.exif
                : exif // ignore: cast_nullable_to_non_nullable
                      as ExifModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of PhotoInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExifModelCopyWith<$Res>? get exif {
    if (_value.exif == null) {
      return null;
    }

    return $ExifModelCopyWith<$Res>(_value.exif!, (value) {
      return _then(_value.copyWith(exif: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PhotoInfoModelImplCopyWith<$Res>
    implements $PhotoInfoModelCopyWith<$Res> {
  factory _$$PhotoInfoModelImplCopyWith(
    _$PhotoInfoModelImpl value,
    $Res Function(_$PhotoInfoModelImpl) then,
  ) = __$$PhotoInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int fileid,
    String basename,
    int? size,
    @JsonKey(name: 'w') int? width,
    @JsonKey(name: 'h') int? height,
    @JsonKey(name: 'datetaken') int? dateTaken,
    String? filename,
    ExifModel? exif,
  });

  @override
  $ExifModelCopyWith<$Res>? get exif;
}

/// @nodoc
class __$$PhotoInfoModelImplCopyWithImpl<$Res>
    extends _$PhotoInfoModelCopyWithImpl<$Res, _$PhotoInfoModelImpl>
    implements _$$PhotoInfoModelImplCopyWith<$Res> {
  __$$PhotoInfoModelImplCopyWithImpl(
    _$PhotoInfoModelImpl _value,
    $Res Function(_$PhotoInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileid = null,
    Object? basename = null,
    Object? size = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? dateTaken = freezed,
    Object? filename = freezed,
    Object? exif = freezed,
  }) {
    return _then(
      _$PhotoInfoModelImpl(
        fileid: null == fileid
            ? _value.fileid
            : fileid // ignore: cast_nullable_to_non_nullable
                  as int,
        basename: null == basename
            ? _value.basename
            : basename // ignore: cast_nullable_to_non_nullable
                  as String,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        dateTaken: freezed == dateTaken
            ? _value.dateTaken
            : dateTaken // ignore: cast_nullable_to_non_nullable
                  as int?,
        filename: freezed == filename
            ? _value.filename
            : filename // ignore: cast_nullable_to_non_nullable
                  as String?,
        exif: freezed == exif
            ? _value.exif
            : exif // ignore: cast_nullable_to_non_nullable
                  as ExifModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoInfoModelImpl implements _PhotoInfoModel {
  const _$PhotoInfoModelImpl({
    required this.fileid,
    required this.basename,
    this.size,
    @JsonKey(name: 'w') this.width,
    @JsonKey(name: 'h') this.height,
    @JsonKey(name: 'datetaken') this.dateTaken,
    this.filename,
    this.exif,
  });

  factory _$PhotoInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoInfoModelImplFromJson(json);

  @override
  final int fileid;
  @override
  final String basename;
  @override
  final int? size;
  @override
  @JsonKey(name: 'w')
  final int? width;
  @override
  @JsonKey(name: 'h')
  final int? height;
  @override
  @JsonKey(name: 'datetaken')
  final int? dateTaken;
  @override
  final String? filename;
  @override
  final ExifModel? exif;

  @override
  String toString() {
    return 'PhotoInfoModel(fileid: $fileid, basename: $basename, size: $size, width: $width, height: $height, dateTaken: $dateTaken, filename: $filename, exif: $exif)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoInfoModelImpl &&
            (identical(other.fileid, fileid) || other.fileid == fileid) &&
            (identical(other.basename, basename) ||
                other.basename == basename) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.dateTaken, dateTaken) ||
                other.dateTaken == dateTaken) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.exif, exif) || other.exif == exif));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fileid,
    basename,
    size,
    width,
    height,
    dateTaken,
    filename,
    exif,
  );

  /// Create a copy of PhotoInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoInfoModelImplCopyWith<_$PhotoInfoModelImpl> get copyWith =>
      __$$PhotoInfoModelImplCopyWithImpl<_$PhotoInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoInfoModelImplToJson(this);
  }
}

abstract class _PhotoInfoModel implements PhotoInfoModel {
  const factory _PhotoInfoModel({
    required final int fileid,
    required final String basename,
    final int? size,
    @JsonKey(name: 'w') final int? width,
    @JsonKey(name: 'h') final int? height,
    @JsonKey(name: 'datetaken') final int? dateTaken,
    final String? filename,
    final ExifModel? exif,
  }) = _$PhotoInfoModelImpl;

  factory _PhotoInfoModel.fromJson(Map<String, dynamic> json) =
      _$PhotoInfoModelImpl.fromJson;

  @override
  int get fileid;
  @override
  String get basename;
  @override
  int? get size;
  @override
  @JsonKey(name: 'w')
  int? get width;
  @override
  @JsonKey(name: 'h')
  int? get height;
  @override
  @JsonKey(name: 'datetaken')
  int? get dateTaken;
  @override
  String? get filename;
  @override
  ExifModel? get exif;

  /// Create a copy of PhotoInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoInfoModelImplCopyWith<_$PhotoInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExifModel _$ExifModelFromJson(Map<String, dynamic> json) {
  return _ExifModel.fromJson(json);
}

/// @nodoc
mixin _$ExifModel {
  @JsonKey(name: 'Make')
  String? get make => throw _privateConstructorUsedError;
  @JsonKey(name: 'Model')
  String? get model => throw _privateConstructorUsedError;
  @JsonKey(name: 'Software')
  String? get software => throw _privateConstructorUsedError;
  @JsonKey(name: 'ImageDescription')
  String? get imageDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'FNumber')
  double? get fNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'ISO')
  int? get iso => throw _privateConstructorUsedError;
  @JsonKey(name: 'ExposureTime')
  double? get exposureTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'FocalLength')
  double? get focalLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'ExposureBiasValue')
  double? get exposureBias => throw _privateConstructorUsedError;
  @JsonKey(name: 'MeteringMode')
  int? get meteringMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'Flash')
  int? get flash => throw _privateConstructorUsedError;
  @JsonKey(name: 'WhiteBalance')
  int? get whiteBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'DateTimeOriginal')
  String? get dateTimeOriginal => throw _privateConstructorUsedError;
  @JsonKey(name: 'GPSLatitude')
  double? get gpsLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'GPSLongitude')
  double? get gpsLongitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'GPSAltitude')
  double? get gpsAltitude => throw _privateConstructorUsedError;

  /// Serializes this ExifModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExifModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExifModelCopyWith<ExifModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExifModelCopyWith<$Res> {
  factory $ExifModelCopyWith(ExifModel value, $Res Function(ExifModel) then) =
      _$ExifModelCopyWithImpl<$Res, ExifModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Make') String? make,
    @JsonKey(name: 'Model') String? model,
    @JsonKey(name: 'Software') String? software,
    @JsonKey(name: 'ImageDescription') String? imageDescription,
    @JsonKey(name: 'FNumber') double? fNumber,
    @JsonKey(name: 'ISO') int? iso,
    @JsonKey(name: 'ExposureTime') double? exposureTime,
    @JsonKey(name: 'FocalLength') double? focalLength,
    @JsonKey(name: 'ExposureBiasValue') double? exposureBias,
    @JsonKey(name: 'MeteringMode') int? meteringMode,
    @JsonKey(name: 'Flash') int? flash,
    @JsonKey(name: 'WhiteBalance') int? whiteBalance,
    @JsonKey(name: 'DateTimeOriginal') String? dateTimeOriginal,
    @JsonKey(name: 'GPSLatitude') double? gpsLatitude,
    @JsonKey(name: 'GPSLongitude') double? gpsLongitude,
    @JsonKey(name: 'GPSAltitude') double? gpsAltitude,
  });
}

/// @nodoc
class _$ExifModelCopyWithImpl<$Res, $Val extends ExifModel>
    implements $ExifModelCopyWith<$Res> {
  _$ExifModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExifModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? make = freezed,
    Object? model = freezed,
    Object? software = freezed,
    Object? imageDescription = freezed,
    Object? fNumber = freezed,
    Object? iso = freezed,
    Object? exposureTime = freezed,
    Object? focalLength = freezed,
    Object? exposureBias = freezed,
    Object? meteringMode = freezed,
    Object? flash = freezed,
    Object? whiteBalance = freezed,
    Object? dateTimeOriginal = freezed,
    Object? gpsLatitude = freezed,
    Object? gpsLongitude = freezed,
    Object? gpsAltitude = freezed,
  }) {
    return _then(
      _value.copyWith(
            make: freezed == make
                ? _value.make
                : make // ignore: cast_nullable_to_non_nullable
                      as String?,
            model: freezed == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String?,
            software: freezed == software
                ? _value.software
                : software // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageDescription: freezed == imageDescription
                ? _value.imageDescription
                : imageDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            fNumber: freezed == fNumber
                ? _value.fNumber
                : fNumber // ignore: cast_nullable_to_non_nullable
                      as double?,
            iso: freezed == iso
                ? _value.iso
                : iso // ignore: cast_nullable_to_non_nullable
                      as int?,
            exposureTime: freezed == exposureTime
                ? _value.exposureTime
                : exposureTime // ignore: cast_nullable_to_non_nullable
                      as double?,
            focalLength: freezed == focalLength
                ? _value.focalLength
                : focalLength // ignore: cast_nullable_to_non_nullable
                      as double?,
            exposureBias: freezed == exposureBias
                ? _value.exposureBias
                : exposureBias // ignore: cast_nullable_to_non_nullable
                      as double?,
            meteringMode: freezed == meteringMode
                ? _value.meteringMode
                : meteringMode // ignore: cast_nullable_to_non_nullable
                      as int?,
            flash: freezed == flash
                ? _value.flash
                : flash // ignore: cast_nullable_to_non_nullable
                      as int?,
            whiteBalance: freezed == whiteBalance
                ? _value.whiteBalance
                : whiteBalance // ignore: cast_nullable_to_non_nullable
                      as int?,
            dateTimeOriginal: freezed == dateTimeOriginal
                ? _value.dateTimeOriginal
                : dateTimeOriginal // ignore: cast_nullable_to_non_nullable
                      as String?,
            gpsLatitude: freezed == gpsLatitude
                ? _value.gpsLatitude
                : gpsLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            gpsLongitude: freezed == gpsLongitude
                ? _value.gpsLongitude
                : gpsLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            gpsAltitude: freezed == gpsAltitude
                ? _value.gpsAltitude
                : gpsAltitude // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExifModelImplCopyWith<$Res>
    implements $ExifModelCopyWith<$Res> {
  factory _$$ExifModelImplCopyWith(
    _$ExifModelImpl value,
    $Res Function(_$ExifModelImpl) then,
  ) = __$$ExifModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Make') String? make,
    @JsonKey(name: 'Model') String? model,
    @JsonKey(name: 'Software') String? software,
    @JsonKey(name: 'ImageDescription') String? imageDescription,
    @JsonKey(name: 'FNumber') double? fNumber,
    @JsonKey(name: 'ISO') int? iso,
    @JsonKey(name: 'ExposureTime') double? exposureTime,
    @JsonKey(name: 'FocalLength') double? focalLength,
    @JsonKey(name: 'ExposureBiasValue') double? exposureBias,
    @JsonKey(name: 'MeteringMode') int? meteringMode,
    @JsonKey(name: 'Flash') int? flash,
    @JsonKey(name: 'WhiteBalance') int? whiteBalance,
    @JsonKey(name: 'DateTimeOriginal') String? dateTimeOriginal,
    @JsonKey(name: 'GPSLatitude') double? gpsLatitude,
    @JsonKey(name: 'GPSLongitude') double? gpsLongitude,
    @JsonKey(name: 'GPSAltitude') double? gpsAltitude,
  });
}

/// @nodoc
class __$$ExifModelImplCopyWithImpl<$Res>
    extends _$ExifModelCopyWithImpl<$Res, _$ExifModelImpl>
    implements _$$ExifModelImplCopyWith<$Res> {
  __$$ExifModelImplCopyWithImpl(
    _$ExifModelImpl _value,
    $Res Function(_$ExifModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExifModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? make = freezed,
    Object? model = freezed,
    Object? software = freezed,
    Object? imageDescription = freezed,
    Object? fNumber = freezed,
    Object? iso = freezed,
    Object? exposureTime = freezed,
    Object? focalLength = freezed,
    Object? exposureBias = freezed,
    Object? meteringMode = freezed,
    Object? flash = freezed,
    Object? whiteBalance = freezed,
    Object? dateTimeOriginal = freezed,
    Object? gpsLatitude = freezed,
    Object? gpsLongitude = freezed,
    Object? gpsAltitude = freezed,
  }) {
    return _then(
      _$ExifModelImpl(
        make: freezed == make
            ? _value.make
            : make // ignore: cast_nullable_to_non_nullable
                  as String?,
        model: freezed == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String?,
        software: freezed == software
            ? _value.software
            : software // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageDescription: freezed == imageDescription
            ? _value.imageDescription
            : imageDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        fNumber: freezed == fNumber
            ? _value.fNumber
            : fNumber // ignore: cast_nullable_to_non_nullable
                  as double?,
        iso: freezed == iso
            ? _value.iso
            : iso // ignore: cast_nullable_to_non_nullable
                  as int?,
        exposureTime: freezed == exposureTime
            ? _value.exposureTime
            : exposureTime // ignore: cast_nullable_to_non_nullable
                  as double?,
        focalLength: freezed == focalLength
            ? _value.focalLength
            : focalLength // ignore: cast_nullable_to_non_nullable
                  as double?,
        exposureBias: freezed == exposureBias
            ? _value.exposureBias
            : exposureBias // ignore: cast_nullable_to_non_nullable
                  as double?,
        meteringMode: freezed == meteringMode
            ? _value.meteringMode
            : meteringMode // ignore: cast_nullable_to_non_nullable
                  as int?,
        flash: freezed == flash
            ? _value.flash
            : flash // ignore: cast_nullable_to_non_nullable
                  as int?,
        whiteBalance: freezed == whiteBalance
            ? _value.whiteBalance
            : whiteBalance // ignore: cast_nullable_to_non_nullable
                  as int?,
        dateTimeOriginal: freezed == dateTimeOriginal
            ? _value.dateTimeOriginal
            : dateTimeOriginal // ignore: cast_nullable_to_non_nullable
                  as String?,
        gpsLatitude: freezed == gpsLatitude
            ? _value.gpsLatitude
            : gpsLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        gpsLongitude: freezed == gpsLongitude
            ? _value.gpsLongitude
            : gpsLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        gpsAltitude: freezed == gpsAltitude
            ? _value.gpsAltitude
            : gpsAltitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExifModelImpl implements _ExifModel {
  const _$ExifModelImpl({
    @JsonKey(name: 'Make') this.make,
    @JsonKey(name: 'Model') this.model,
    @JsonKey(name: 'Software') this.software,
    @JsonKey(name: 'ImageDescription') this.imageDescription,
    @JsonKey(name: 'FNumber') this.fNumber,
    @JsonKey(name: 'ISO') this.iso,
    @JsonKey(name: 'ExposureTime') this.exposureTime,
    @JsonKey(name: 'FocalLength') this.focalLength,
    @JsonKey(name: 'ExposureBiasValue') this.exposureBias,
    @JsonKey(name: 'MeteringMode') this.meteringMode,
    @JsonKey(name: 'Flash') this.flash,
    @JsonKey(name: 'WhiteBalance') this.whiteBalance,
    @JsonKey(name: 'DateTimeOriginal') this.dateTimeOriginal,
    @JsonKey(name: 'GPSLatitude') this.gpsLatitude,
    @JsonKey(name: 'GPSLongitude') this.gpsLongitude,
    @JsonKey(name: 'GPSAltitude') this.gpsAltitude,
  });

  factory _$ExifModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExifModelImplFromJson(json);

  @override
  @JsonKey(name: 'Make')
  final String? make;
  @override
  @JsonKey(name: 'Model')
  final String? model;
  @override
  @JsonKey(name: 'Software')
  final String? software;
  @override
  @JsonKey(name: 'ImageDescription')
  final String? imageDescription;
  @override
  @JsonKey(name: 'FNumber')
  final double? fNumber;
  @override
  @JsonKey(name: 'ISO')
  final int? iso;
  @override
  @JsonKey(name: 'ExposureTime')
  final double? exposureTime;
  @override
  @JsonKey(name: 'FocalLength')
  final double? focalLength;
  @override
  @JsonKey(name: 'ExposureBiasValue')
  final double? exposureBias;
  @override
  @JsonKey(name: 'MeteringMode')
  final int? meteringMode;
  @override
  @JsonKey(name: 'Flash')
  final int? flash;
  @override
  @JsonKey(name: 'WhiteBalance')
  final int? whiteBalance;
  @override
  @JsonKey(name: 'DateTimeOriginal')
  final String? dateTimeOriginal;
  @override
  @JsonKey(name: 'GPSLatitude')
  final double? gpsLatitude;
  @override
  @JsonKey(name: 'GPSLongitude')
  final double? gpsLongitude;
  @override
  @JsonKey(name: 'GPSAltitude')
  final double? gpsAltitude;

  @override
  String toString() {
    return 'ExifModel(make: $make, model: $model, software: $software, imageDescription: $imageDescription, fNumber: $fNumber, iso: $iso, exposureTime: $exposureTime, focalLength: $focalLength, exposureBias: $exposureBias, meteringMode: $meteringMode, flash: $flash, whiteBalance: $whiteBalance, dateTimeOriginal: $dateTimeOriginal, gpsLatitude: $gpsLatitude, gpsLongitude: $gpsLongitude, gpsAltitude: $gpsAltitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExifModelImpl &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.software, software) ||
                other.software == software) &&
            (identical(other.imageDescription, imageDescription) ||
                other.imageDescription == imageDescription) &&
            (identical(other.fNumber, fNumber) || other.fNumber == fNumber) &&
            (identical(other.iso, iso) || other.iso == iso) &&
            (identical(other.exposureTime, exposureTime) ||
                other.exposureTime == exposureTime) &&
            (identical(other.focalLength, focalLength) ||
                other.focalLength == focalLength) &&
            (identical(other.exposureBias, exposureBias) ||
                other.exposureBias == exposureBias) &&
            (identical(other.meteringMode, meteringMode) ||
                other.meteringMode == meteringMode) &&
            (identical(other.flash, flash) || other.flash == flash) &&
            (identical(other.whiteBalance, whiteBalance) ||
                other.whiteBalance == whiteBalance) &&
            (identical(other.dateTimeOriginal, dateTimeOriginal) ||
                other.dateTimeOriginal == dateTimeOriginal) &&
            (identical(other.gpsLatitude, gpsLatitude) ||
                other.gpsLatitude == gpsLatitude) &&
            (identical(other.gpsLongitude, gpsLongitude) ||
                other.gpsLongitude == gpsLongitude) &&
            (identical(other.gpsAltitude, gpsAltitude) ||
                other.gpsAltitude == gpsAltitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    make,
    model,
    software,
    imageDescription,
    fNumber,
    iso,
    exposureTime,
    focalLength,
    exposureBias,
    meteringMode,
    flash,
    whiteBalance,
    dateTimeOriginal,
    gpsLatitude,
    gpsLongitude,
    gpsAltitude,
  );

  /// Create a copy of ExifModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExifModelImplCopyWith<_$ExifModelImpl> get copyWith =>
      __$$ExifModelImplCopyWithImpl<_$ExifModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExifModelImplToJson(this);
  }
}

abstract class _ExifModel implements ExifModel {
  const factory _ExifModel({
    @JsonKey(name: 'Make') final String? make,
    @JsonKey(name: 'Model') final String? model,
    @JsonKey(name: 'Software') final String? software,
    @JsonKey(name: 'ImageDescription') final String? imageDescription,
    @JsonKey(name: 'FNumber') final double? fNumber,
    @JsonKey(name: 'ISO') final int? iso,
    @JsonKey(name: 'ExposureTime') final double? exposureTime,
    @JsonKey(name: 'FocalLength') final double? focalLength,
    @JsonKey(name: 'ExposureBiasValue') final double? exposureBias,
    @JsonKey(name: 'MeteringMode') final int? meteringMode,
    @JsonKey(name: 'Flash') final int? flash,
    @JsonKey(name: 'WhiteBalance') final int? whiteBalance,
    @JsonKey(name: 'DateTimeOriginal') final String? dateTimeOriginal,
    @JsonKey(name: 'GPSLatitude') final double? gpsLatitude,
    @JsonKey(name: 'GPSLongitude') final double? gpsLongitude,
    @JsonKey(name: 'GPSAltitude') final double? gpsAltitude,
  }) = _$ExifModelImpl;

  factory _ExifModel.fromJson(Map<String, dynamic> json) =
      _$ExifModelImpl.fromJson;

  @override
  @JsonKey(name: 'Make')
  String? get make;
  @override
  @JsonKey(name: 'Model')
  String? get model;
  @override
  @JsonKey(name: 'Software')
  String? get software;
  @override
  @JsonKey(name: 'ImageDescription')
  String? get imageDescription;
  @override
  @JsonKey(name: 'FNumber')
  double? get fNumber;
  @override
  @JsonKey(name: 'ISO')
  int? get iso;
  @override
  @JsonKey(name: 'ExposureTime')
  double? get exposureTime;
  @override
  @JsonKey(name: 'FocalLength')
  double? get focalLength;
  @override
  @JsonKey(name: 'ExposureBiasValue')
  double? get exposureBias;
  @override
  @JsonKey(name: 'MeteringMode')
  int? get meteringMode;
  @override
  @JsonKey(name: 'Flash')
  int? get flash;
  @override
  @JsonKey(name: 'WhiteBalance')
  int? get whiteBalance;
  @override
  @JsonKey(name: 'DateTimeOriginal')
  String? get dateTimeOriginal;
  @override
  @JsonKey(name: 'GPSLatitude')
  double? get gpsLatitude;
  @override
  @JsonKey(name: 'GPSLongitude')
  double? get gpsLongitude;
  @override
  @JsonKey(name: 'GPSAltitude')
  double? get gpsAltitude;

  /// Create a copy of ExifModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExifModelImplCopyWith<_$ExifModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
