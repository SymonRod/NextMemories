import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/widget_album_config.dart';
import '../repositories/i_widget_repository.dart';

class GetPinnedAlbumUseCase {
  final IWidgetRepository _repo;
  const GetPinnedAlbumUseCase(this._repo);

  Future<Either<Failure, Option<WidgetAlbumConfig>>> call() => _repo.getPinnedAlbum();
}
