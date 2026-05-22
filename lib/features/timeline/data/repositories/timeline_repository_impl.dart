import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_day.dart';
import '../../domain/repositories/i_timeline_repository.dart';
import '../datasources/timeline_remote_datasource.dart';
import '../models/photo_day_model.dart';
import '../models/photo_model.dart';

class TimelineRepositoryImpl implements ITimelineRepository {
  final TimelineRemoteDatasource _remote;
  const TimelineRepositoryImpl(this._remote);

  factory TimelineRepositoryImpl.fromConfig(ServerConfig config) =>
      TimelineRepositoryImpl(TimelineRemoteDatasource(config));

  @override
  Future<Either<Failure, List<PhotoDay>>> getDays() async {
    try {
      final models = await _remote.getDays();
      final days = models.map((m) => m.toEntity()).toList()
        ..sort((a, b) => b.dayId.compareTo(a.dayId));
      return Right(days);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Sessione scaduta'));
      }
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure(
          "L'app Memories non è raggiungibile sul server.\n"
          "Verifica che sia installata e attiva in Nextcloud.",
        ));
      }
      return Left(NetworkFailure(e.message ?? 'Errore di rete'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Photo>>> getDayPhotos(int dayId) async {
    try {
      final models = await _remote.getDayPhotos(dayId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Sessione scaduta'));
      }
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure('Giorno non trovato sul server'));
      }
      return Left(NetworkFailure(e.message ?? 'Errore di rete'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
