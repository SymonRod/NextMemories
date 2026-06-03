import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_albums_repository.dart';

class AddPhotosToAlbumUseCase {
  final IAlbumsRepository _repo;
  const AddPhotosToAlbumUseCase(this._repo);

  Future<Either<Failure, void>> call(String albumName, List<int> fileIds) =>
      _repo.addPhotosToAlbum(albumName, fileIds);
}
