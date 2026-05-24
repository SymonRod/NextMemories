import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/sync_rule.dart';
import '../repositories/i_sync_repository.dart';

class SaveSyncRuleUseCase {
  final ISyncRepository _repo;
  const SaveSyncRuleUseCase(this._repo);

  Future<Either<Failure, SyncRule>> call(SyncRule rule) async {
    final existing = await _repo.getSyncRules();
    return existing.fold<Future<Either<Failure, SyncRule>>>(
      (failure) async => Left(failure),
      (rules) async {
        final duplicate = rules.any((r) {
          if (r.id == rule.id) return false; // ignora se stessa (update)
          if (r.type != rule.type) return false;
          return switch (rule.type) {
            SyncRuleType.album => r.clusterId == rule.clusterId,
            SyncRuleType.timeRange => r.daysBack == rule.daysBack,
          };
        });

        if (duplicate) {
          final what = rule.type == SyncRuleType.album
              ? 'questo album'
              : 'questo intervallo';
          return Left(ValidationFailure('Esiste già una regola per $what.'));
        }
        return _repo.saveSyncRule(rule);
      },
    );
  }
}
