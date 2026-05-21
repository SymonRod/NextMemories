import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_info.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, UserInfo>> getUserInfo();
}
