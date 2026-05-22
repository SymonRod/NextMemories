import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

@freezed
class Album with _$Album {
  const factory Album({
    required String clusterId,
    required String name,
    required int count,
    required int lastAddedPhoto,
    String? lastAddedPhotoEtag,
  }) = _Album;
}
