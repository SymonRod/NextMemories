import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/photo.dart';
import '../entities/photo_day.dart';

/// Day list + photos grouped by dayId, both derived from a single GET /days.
typedef TimelineData = ({List<PhotoDay> days, Map<int, List<Photo>> photosByDay});

abstract class ITimelineRepository {
  Future<Either<Failure, List<PhotoDay>>> getDays();
  Future<Either<Failure, List<Photo>>> getDayPhotos(int dayId);
  Future<Either<Failure, List<Photo>>> getDaysPhotos(List<int> dayIds);

  /// Loads the whole timeline in a single GET /days (using inline detail) plus
  /// at most one batch POST /days for days whose detail is missing/truncated.
  /// Returns both the sorted day list and the photos grouped by dayId so the
  /// caller never has to fetch /days twice.
  Future<Either<Failure, TimelineData>> getTimeline();
}
