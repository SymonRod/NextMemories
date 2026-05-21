import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/server_config.dart';
import '../repositories/i_auth_repository.dart';

class ValidateConnectionUseCase {
  final IAuthRepository _repository;
  const ValidateConnectionUseCase(this._repository);

  Future<Either<Failure, Unit>> call(ServerConfig config) =>
      _repository.validateConnection(config);
}
