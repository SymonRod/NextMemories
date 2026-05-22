import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/photo.dart';
import '../repositories/i_timeline_repository.dart';

class GetDayPhotosUseCase {
  final ITimelineRepository _repo;
  const GetDayPhotosUseCase(this._repo);

  Future<Either<Failure, List<Photo>>> call(int dayId) =>
      _repo.getDayPhotos(dayId);
}
