import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_info_model.freezed.dart';
part 'photo_info_model.g.dart';

@freezed
class PhotoInfoModel with _$PhotoInfoModel {
  const factory PhotoInfoModel({
    required int fileid,
    required String basename,
    int? size,
    @JsonKey(name: 'w') int? width,
    @JsonKey(name: 'h') int? height,
    @JsonKey(name: 'datetaken') int? dateTaken,
    String? filename,
    ExifModel? exif,
  }) = _PhotoInfoModel;

  factory PhotoInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoInfoModelFromJson(json);
}

@freezed
class ExifModel with _$ExifModel {
  const factory ExifModel({
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
  }) = _ExifModel;

  factory ExifModel.fromJson(Map<String, dynamic> json) =>
      _$ExifModelFromJson(json);
}
