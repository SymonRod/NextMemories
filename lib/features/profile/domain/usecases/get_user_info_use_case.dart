import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_info.dart';
import '../repositories/i_profile_repository.dart';

class GetUserInfoUseCase {
  final IProfileRepository _repository;
  const GetUserInfoUseCase(this._repository);

  Future<Either<Failure, UserInfo>> call() => _repository.getUserInfo();
}
