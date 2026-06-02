import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/widget_album_config.dart';
import '../repositories/i_widget_repository.dart';

class PinAlbumToWidgetUseCase {
  final IWidgetRepository _repo;
  const PinAlbumToWidgetUseCase(this._repo);

  Future<Either<Failure, Unit>> call(WidgetAlbumConfig config) => _repo.pinAlbum(config);
}
