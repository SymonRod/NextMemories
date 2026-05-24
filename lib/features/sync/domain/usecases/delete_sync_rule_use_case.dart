import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_sync_repository.dart';

class DeleteSyncRuleUseCase {
  final ISyncRepository _repo;
  const DeleteSyncRuleUseCase(this._repo);

  Future<Either<Failure, Unit>> call(int ruleId) =>
      _repo.deleteSyncRule(ruleId);
}
