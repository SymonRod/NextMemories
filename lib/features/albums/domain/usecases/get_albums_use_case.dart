import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/album.dart';
import '../repositories/i_albums_repository.dart';

class GetAlbumsUseCase {
  final IAlbumsRepository _repo;
  const GetAlbumsUseCase(this._repo);

  Future<Either<Failure, List<Album>>> call() => _repo.getAlbums();
}
