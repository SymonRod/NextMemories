import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/sync_rule.dart';
import '../repositories/i_sync_repository.dart';

class GetSyncRulesUseCase {
  final ISyncRepository _repo;
  const GetSyncRulesUseCase(this._repo);

  Future<Either<Failure, List<SyncRule>>> call() => _repo.getSyncRules();
}
