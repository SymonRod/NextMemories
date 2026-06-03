import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_albums_repository.dart';

class RemovePhotosFromAlbumUseCase {
  final IAlbumsRepository _repo;
  const RemovePhotosFromAlbumUseCase(this._repo);

  Future<Either<Failure, void>> call(
    String albumName,
    Map<int, String> fileIdToBasename,
  ) =>
      _repo.removePhotosFromAlbum(albumName, fileIdToBasename);
}
