import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_albums_repository.dart';

class CreateAlbumUseCase {
  final IAlbumsRepository _repository;
  const CreateAlbumUseCase(this._repository);

  Future<Either<Failure, void>> call(String albumName) =>
      _repository.createAlbum(albumName);
}
