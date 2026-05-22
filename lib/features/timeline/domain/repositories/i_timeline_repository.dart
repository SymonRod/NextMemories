import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/photo.dart';
import '../entities/photo_day.dart';

abstract class ITimelineRepository {
  Future<Either<Failure, List<PhotoDay>>> getDays();
  Future<Either<Failure, List<Photo>>> getDayPhotos(int dayId);
}
