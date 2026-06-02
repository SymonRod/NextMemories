import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_widget_repository.dart';

class RefreshAlbumWidgetUseCase {
  final IWidgetRepository _repo;
  const RefreshAlbumWidgetUseCase(this._repo);

  Future<Either<Failure, Unit>> call() => _repo.refreshWidget();
}
