// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlbumModelImpl _$$AlbumModelImplFromJson(Map<String, dynamic> json) =>
    _$AlbumModelImpl(
      clusterId: json['cluster_id'] as String,
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
      lastAddedPhoto: (json['last_added_photo'] as num).toInt(),
      lastAddedPhotoEtag: json['last_added_photo_etag'] as String?,
    );

Map<String, dynamic> _$$AlbumModelImplToJson(_$AlbumModelImpl instance) =>
    <String, dynamic>{
      'cluster_id': instance.clusterId,
      'name': instance.name,
      'count': instance.count,
      'last_added_photo': instance.lastAddedPhoto,
      'last_added_photo_etag': instance.lastAddedPhotoEtag,
    };
