import '../entities/sync_status.dart';
import '../repositories/i_sync_repository.dart';

class RunSyncUseCase {
  final ISyncRepository _repo;
  const RunSyncUseCase(this._repo);

  Stream<SyncProgress> call() => _repo.runSync();
}
