import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../entities/album.dart';

abstract interface class IAlbumsRepository {
  Future<Either<Failure, List<Album>>> getAlbums();
  Future<Either<Failure, List<Photo>>> getAlbumPhotos(String clusterId);
  Future<Either<Failure, void>> createAlbum(String albumName);
  Future<Either<Failure, void>> deleteAlbum(String albumName);
  Future<Either<Failure, void>> addPhotosToAlbum(String albumName, List<int> fileIds);
  Future<Either<Failure, void>> removePhotosFromAlbum(
      String albumName, Map<int, String> fileIdToBasename);
}
