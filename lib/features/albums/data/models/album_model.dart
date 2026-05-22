import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/album.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    @JsonKey(name: 'cluster_id') required String clusterId,
    required String name,
    required int count,
    @JsonKey(name: 'last_added_photo') required int lastAddedPhoto,
    @JsonKey(name: 'last_added_photo_etag') String? lastAddedPhotoEtag,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);
}

extension AlbumModelX on AlbumModel {
  Album toEntity() => Album(
        clusterId: clusterId,
        name: name,
        count: count,
        lastAddedPhoto: lastAddedPhoto,
        lastAddedPhotoEtag: lastAddedPhotoEtag,
      );
}
