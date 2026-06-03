// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoInfoModelImpl _$$PhotoInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$PhotoInfoModelImpl(
      fileid: (json['fileid'] as num).toInt(),
      basename: json['basename'] as String,
      size: (json['size'] as num?)?.toInt(),
      width: (json['w'] as num?)?.toInt(),
      height: (json['h'] as num?)?.toInt(),
      dateTaken: (json['datetaken'] as num?)?.toInt(),
      filename: json['filename'] as String?,
      exif: json['exif'] == null
          ? null
          : ExifModel.fromJson(json['exif'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PhotoInfoModelImplToJson(
  _$PhotoInfoModelImpl instance,
) => <String, dynamic>{
  'fileid': instance.fileid,
  'basename': instance.basename,
  'size': instance.size,
  'w': instance.width,
  'h': instance.height,
  'datetaken': instance.dateTaken,
  'filename': instance.filename,
  'exif': instance.exif,
};

_$ExifModelImpl _$$ExifModelImplFromJson(Map<String, dynamic> json) =>
    _$ExifModelImpl(
      make: json['Make'] as String?,
      model: json['Model'] as String?,
      software: json['Software'] as String?,
      imageDescription: json['ImageDescription'] as String?,
      fNumber: (json['FNumber'] as num?)?.toDouble(),
      iso: (json['ISO'] as num?)?.toInt(),
      exposureTime: (json['ExposureTime'] as num?)?.toDouble(),
      focalLength: (json['FocalLength'] as num?)?.toDouble(),
      exposureBias: (json['ExposureBiasValue'] as num?)?.toDouble(),
      meteringMode: (json['MeteringMode'] as num?)?.toInt(),
      flash: (json['Flash'] as num?)?.toInt(),
      whiteBalance: (json['WhiteBalance'] as num?)?.toInt(),
      dateTimeOriginal: json['DateTimeOriginal'] as String?,
      gpsLatitude: (json['GPSLatitude'] as num?)?.toDouble(),
      gpsLongitude: (json['GPSLongitude'] as num?)?.toDouble(),
      gpsAltitude: (json['GPSAltitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ExifModelImplToJson(_$ExifModelImpl instance) =>
    <String, dynamic>{
      'Make': instance.make,
      'Model': instance.model,
      'Software': instance.software,
      'ImageDescription': instance.imageDescription,
      'FNumber': instance.fNumber,
      'ISO': instance.iso,
      'ExposureTime': instance.exposureTime,
      'FocalLength': instance.focalLength,
      'ExposureBiasValue': instance.exposureBias,
      'MeteringMode': instance.meteringMode,
      'Flash': instance.flash,
      'WhiteBalance': instance.whiteBalance,
      'DateTimeOriginal': instance.dateTimeOriginal,
      'GPSLatitude': instance.gpsLatitude,
      'GPSLongitude': instance.gpsLongitude,
      'GPSAltitude': instance.gpsAltitude,
    };
