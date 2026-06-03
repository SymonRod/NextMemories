import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_albums_repository.dart';

class DeleteAlbumUseCase {
  final IAlbumsRepository _repository;
  const DeleteAlbumUseCase(this._repository);

  Future<Either<Failure, void>> call(String albumName) =>
      _repository.deleteAlbum(albumName);
}
