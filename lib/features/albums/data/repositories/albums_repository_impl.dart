import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../../../features/timeline/data/models/photo_model.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../../domain/entities/album.dart';
import '../../domain/repositories/i_albums_repository.dart';
import '../datasources/albums_remote_datasource.dart';
import '../models/album_model.dart';

class AlbumsRepositoryImpl implements IAlbumsRepository {
  final AlbumsRemoteDatasource _remote;
  const AlbumsRepositoryImpl(this._remote);

  factory AlbumsRepositoryImpl.fromConfig(ServerConfig config) =>
      AlbumsRepositoryImpl(AlbumsRemoteDatasource(config));

  @override
  Future<Either<Failure, List<Album>>> getAlbums() async {
    try {
      final models = await _remote.getAlbums();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Sessione scaduta'));
      }
      return Left(NetworkFailure(e.message ?? 'Errore di rete'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Photo>>> getAlbumPhotos(String clusterId) async {
    try {
      final models = await _remote.getAlbumPhotos(clusterId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Sessione scaduta'));
      }
      return Left(NetworkFailure(e.message ?? 'Errore di rete'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
