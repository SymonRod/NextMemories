import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/sync_rule.dart';
import '../entities/sync_status.dart';

abstract class ISyncRepository {
  Future<Either<Failure, List<SyncRule>>> getSyncRules();

  Future<Either<Failure, SyncRule>> saveSyncRule(SyncRule rule);

  Future<Either<Failure, Unit>> deleteSyncRule(int ruleId);

  Stream<SyncProgress> runSync();

  Future<Either<Failure, String?>> getLocalPath(int fileId);

  /// Batch lookup of local paths for multiple file IDs (single DB query).
  Future<Map<int, String>> getLocalPaths(Set<int> fileIds);

  /// Local file paths of all cached photos belonging to [ruleId].
  Future<Either<Failure, List<String>>> getLocalPhotoPathsForRule(int ruleId);

  Future<Either<Failure, ({int fileCount, int sizeBytes})>> getCacheStatsForRule(int ruleId);

  Future<Either<Failure, int>> getTotalCacheBytes();
}
