import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/photo.dart';

part 'photo_model.freezed.dart';
part 'photo_model.g.dart';

@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    @JsonKey(name: 'fileid') required int fileId,
    @JsonKey(name: 'dayid') required int dayId,
    required String basename,
    required int epoch,
    required String mimetype,
    @JsonKey(name: 'w') int? width,
    @JsonKey(name: 'h') int? height,
    String? etag,
    String? auid,
    @JsonKey(name: 'isvideo') int? isVideoRaw,
    @JsonKey(name: 'isfavorite') int? isFavoriteRaw,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);
}

extension PhotoModelX on PhotoModel {
  Photo toEntity() => Photo(
        fileId: fileId,
        dayId: dayId,
        basename: basename,
        epoch: epoch,
        mimetype: mimetype,
        width: width,
        height: height,
        etag: etag,
        auid: auid,
        isVideo: (isVideoRaw ?? 0) == 1,
        isFavorite: (isFavoriteRaw ?? 0) == 1,
      );
}
