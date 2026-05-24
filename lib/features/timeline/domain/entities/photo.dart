import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';

@freezed
class Photo with _$Photo {
  const factory Photo({
    required int fileId,
    required int dayId,
    required String basename,
    required int epoch,
    required String mimetype,
    int? width,
    int? height,
    String? etag,
    String? auid,
    @Default(false) bool isVideo,
    @Default(false) bool isFavorite,
    @Default(null) String? localPath,
  }) = _Photo;
}
