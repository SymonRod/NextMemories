import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../entities/album.dart';

abstract interface class IAlbumsRepository {
  Future<Either<Failure, List<Album>>> getAlbums();
  Future<Either<Failure, List<Photo>>> getAlbumPhotos(String clusterId);
}
