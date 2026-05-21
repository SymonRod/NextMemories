import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/server_config.dart';
import '../repositories/i_auth_repository.dart';

class GetCredentialsUseCase {
  final IAuthRepository _repository;
  const GetCredentialsUseCase(this._repository);

  Future<Either<Failure, ServerConfig>> call() => _repository.getCredentials();
}
