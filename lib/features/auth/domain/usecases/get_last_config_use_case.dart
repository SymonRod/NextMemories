import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/server_config.dart';
import '../repositories/i_auth_repository.dart';

class GetLastConfigUseCase {
  final IAuthRepository _repo;
  const GetLastConfigUseCase(this._repo);

  Future<Either<Failure, ServerConfig?>> call() => _repo.getLastConfig();
}
