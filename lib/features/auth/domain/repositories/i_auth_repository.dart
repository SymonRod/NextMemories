import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/server_config.dart';

abstract class IAuthRepository {
  Future<Either<Failure, ServerConfig>> getCredentials();
  Future<Either<Failure, Unit>> saveCredentials(ServerConfig config);
  Future<Either<Failure, Unit>> clearCredentials();
  Future<Either<Failure, Unit>> validateConnection(ServerConfig config);
  Future<Either<Failure, ServerConfig?>> getLastConfig();
  Future<Either<Failure, Unit>> saveLastConfig(ServerConfig config);
}
