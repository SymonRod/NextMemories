// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoModelImpl _$$PhotoModelImplFromJson(Map<String, dynamic> json) =>
    _$PhotoModelImpl(
      fileId: (json['fileid'] as num).toInt(),
      dayId: (json['dayid'] as num).toInt(),
      basename: json['basename'] as String,
      epoch: (json['epoch'] as num).toInt(),
      mimetype: json['mimetype'] as String,
      width: (json['w'] as num?)?.toInt(),
      height: (json['h'] as num?)?.toInt(),
      etag: json['etag'] as String?,
      auid: json['auid'] as String?,
      isVideoRaw: (json['isvideo'] as num?)?.toInt(),
      isFavoriteRaw: (json['isfavorite'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PhotoModelImplToJson(_$PhotoModelImpl instance) =>
    <String, dynamic>{
      'fileid': instance.fileId,
      'dayid': instance.dayId,
      'basename': instance.basename,
      'epoch': instance.epoch,
      'mimetype': instance.mimetype,
      'w': instance.width,
      'h': instance.height,
      'etag': instance.etag,
      'auid': instance.auid,
      'isvideo': instance.isVideoRaw,
      'isfavorite': instance.isFavoriteRaw,
    };
