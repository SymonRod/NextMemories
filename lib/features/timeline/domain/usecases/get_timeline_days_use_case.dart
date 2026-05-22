import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/photo_day.dart';
import '../repositories/i_timeline_repository.dart';

class GetTimelineDaysUseCase {
  final ITimelineRepository _repo;
  const GetTimelineDaysUseCase(this._repo);

  Future<Either<Failure, List<PhotoDay>>> call() => _repo.getDays();
}
