import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_widget_repository.dart';

class UnpinAlbumFromWidgetUseCase {
  final IWidgetRepository _repo;
  const UnpinAlbumFromWidgetUseCase(this._repo);

  Future<Either<Failure, Unit>> call() => _repo.unpinAlbum();
}
