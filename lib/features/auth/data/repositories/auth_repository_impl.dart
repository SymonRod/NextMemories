import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/server_config_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthLocalDatasource _local;
  const AuthRepositoryImpl(this._local);

  static AuthRepositoryImpl get instance => AuthRepositoryImpl(
        const AuthLocalDatasource(FlutterSecureStorage()),
      );

  @override
  Future<Either<Failure, ServerConfig>> getCredentials() async {
    try {
      final model = await _local.getConfig();
      if (model == null) return const Left(AuthFailure('Nessuna credenziale salvata'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveCredentials(ServerConfig config) async {
    try {
      await _local.saveConfig(config.toModel());
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCredentials() async {
    try {
      await _local.clearConfig();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServerConfig?>> getLastConfig() async {
    try {
      final model = await _local.getLastConfig();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastConfig(ServerConfig config) async {
    try {
      await _local.saveLastConfig(config.toModel());
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> validateConnection(ServerConfig config) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: config.serverUrl));
      dio.interceptors.add(AuthInterceptor(
        username: config.username,
        appPassword: config.appPassword,
      ));
      final response = await dio.get(
        '/ocs/v2.php/cloud/capabilities',
        queryParameters: {'format': 'json'},
        options: Options(validateStatus: (s) => s != null),
      );
      if (response.statusCode == 200) return const Right(unit);
      if (response.statusCode == 401) {
        return const Left(AuthFailure('Credenziali non valide'));
      }
      return Left(ServerFailure('Errore server: ${response.statusCode}'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return const Left(NetworkFailure('Impossibile raggiungere il server'));
      }
      return Left(NetworkFailure(e.message ?? 'Errore di rete'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
