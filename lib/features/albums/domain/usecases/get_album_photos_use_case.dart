import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../repositories/i_albums_repository.dart';

class GetAlbumPhotosUseCase {
  final IAlbumsRepository _repo;
  const GetAlbumPhotosUseCase(this._repo);

  Future<Either<Failure, List<Photo>>> call(String clusterId) =>
      _repo.getAlbumPhotos(clusterId);
}
