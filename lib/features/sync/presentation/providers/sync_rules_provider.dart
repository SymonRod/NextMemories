import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_provider.dart';
import '../../../albums/data/repositories/albums_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../timeline/data/repositories/timeline_repository_impl.dart';
import '../../data/datasources/sync_download_datasource.dart';
import '../../data/datasources/sync_local_datasource.dart';
import '../../data/repositories/sync_repository_impl.dart';
import '../../domain/entities/sync_rule.dart';
import '../../domain/repositories/i_sync_repository.dart';
import '../../domain/usecases/delete_sync_rule_use_case.dart';
import '../../domain/usecases/get_sync_rules_use_case.dart';
import '../../domain/usecases/save_sync_rule_use_case.dart';

part 'sync_rules_provider.g.dart';

@Riverpod(keepAlive: true)
ISyncRepository syncRepository(Ref ref) {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final db = ref.watch(appDatabaseProvider);
  return SyncRepositoryImpl(
    local: SyncLocalDatasource(db),
    download: SyncDownloadDatasource(config),
    timeline: TimelineRepositoryImpl.fromConfig(config),
    albums: AlbumsRepositoryImpl.fromConfig(config),
  );
}

@riverpod
Future<({int fileCount, int sizeBytes})> syncRuleStats(Ref ref, int ruleId) async {
  final repo = ref.watch(syncRepositoryProvider);
  final result = await repo.getCacheStatsForRule(ruleId);
  return result.fold((f) => throw Exception(f.message), (s) => s);
}

@riverpod
Future<int> syncTotalCacheBytes(Ref ref) async {
  final repo = ref.watch(syncRepositoryProvider);
  final result = await repo.getTotalCacheBytes();
  return result.fold((f) => throw Exception(f.message), (bytes) => bytes);
}

@riverpod
class SyncRules extends _$SyncRules {
  late ISyncRepository _repo;

  @override
  Future<List<SyncRule>> build() async {
    _repo = ref.watch(syncRepositoryProvider);
    final result = await GetSyncRulesUseCase(_repo)();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (rules) => rules,
    );
  }

  Future<void> saveRule(SyncRule rule) async {
    final result = await SaveSyncRuleUseCase(_repo)(rule);
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );
    ref.invalidateSelf();
  }

  Future<void> deleteRule(int ruleId) async {
    final result = await DeleteSyncRuleUseCase(_repo)(ruleId);
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );
    ref.invalidateSelf();
  }
}
