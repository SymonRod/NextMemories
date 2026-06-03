// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/error/failures.dart';
import '../../../albums/domain/repositories/i_albums_repository.dart';
import '../../../timeline/domain/entities/photo.dart';
import '../../../timeline/domain/entities/photo_day.dart';
import '../../../timeline/domain/repositories/i_timeline_repository.dart';
import '../../domain/entities/sync_rule.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/i_sync_repository.dart';
import '../datasources/sync_download_datasource.dart';
import '../datasources/sync_local_datasource.dart';
import '../models/sync_rule_model.dart';

class SyncRepositoryImpl implements ISyncRepository {
  final SyncLocalDatasource _local;
  final SyncDownloadDatasource _download;
  final ITimelineRepository _timeline;
  final IAlbumsRepository _albums;

  const SyncRepositoryImpl({
    required SyncLocalDatasource local,
    required SyncDownloadDatasource download,
    required ITimelineRepository timeline,
    required IAlbumsRepository albums,
  })  : _local = local,
        _download = download,
        _timeline = timeline,
        _albums = albums;

  @override
  Future<Either<Failure, List<SyncRule>>> getSyncRules() async {
    try {
      final rows = await _local.getRules();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SyncRule>> saveSyncRule(SyncRule rule) async {
    try {
      final row = await _local.upsertRule(rule.toCompanion());
      return Right(row.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSyncRule(int ruleId) async {
    try {
      final entries = await _local.getCacheEntriesForRule(ruleId);

      // Controlla il reference counting PRIMA di cancellare le righe,
      // così excludeRuleId esclude correttamente questa regola dai conteggi.
      for (final entry in entries) {
        final otherRefs = await _local.countRefs(
          entry.fileId,
          entry.downloadFull,
          excludeRuleId: ruleId,
        );
        if (otherRefs == 0) {
          final file = File(entry.localPath);
          if (await file.exists()) await file.delete();
        }
      }

      await _local.deleteCacheEntriesForRule(ruleId);
      await _local.deleteRule(ruleId);

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  static const _downloadConcurrency = 5;

  @override
  Stream<SyncProgress> runSync() async* {
    yield SyncProgress.idle().copyWith(status: SyncStatus.running);

    try {
      await _download.cleanupPartFiles();

      final dbRules = await _local.getRules();
      final rules = dbRules.map((r) => r.toEntity()).toList();

      int total = 0;
      int downloaded = 0;
      int failed = 0;

      for (final rule in rules) {
        final expectedPhotos = await _getExpectedPhotos(rule);
        final existingEntries = await _local.getCacheEntriesForRule(rule.id);

        final existingByFileId = {for (final e in existingEntries) e.fileId: e};
        final expectedFileIds = {for (final p in expectedPhotos) p.fileId};

        final toDownload = expectedPhotos.where((photo) {
          final existing = existingByFileId[photo.fileId];
          if (existing == null) return true;
          if (photo.etag != null && photo.etag!.isNotEmpty) {
            return existing.etag != photo.etag;
          }
          return false;
        }).toList();

        final toPrune =
            existingEntries.where((e) => !expectedFileIds.contains(e.fileId)).toList();

        total += toDownload.length;
        yield SyncProgress(
          status: SyncStatus.running,
          total: total,
          downloaded: downloaded,
          failed: failed,
        );

        // S6 — parallel download pool with bounded concurrency.
        final controller = StreamController<SyncProgress>();
        final queue = Queue<Photo>.from(toDownload);

        Future<void> worker() async {
          while (queue.isNotEmpty) {
            final photo = queue.removeFirst();
            try {
              final result = rule.downloadFull
                  ? await _download.downloadOriginal(
                      fileId: photo.fileId,
                      basename: photo.basename,
                      mimetype: photo.mimetype,
                    )
                  : await _download.downloadPreview(
                      fileId: photo.fileId,
                      etag: photo.etag ?? '',
                      basename: photo.basename,
                      mimetype: photo.mimetype,
                    );

              await _local.insertOrUpdateCacheEntry(db.SyncCacheEntriesCompanion(
                fileId: Value(photo.fileId),
                ruleId: Value(rule.id),
                downloadFull: Value(rule.downloadFull),
                localPath: Value(result.localPath),
                etag: Value(photo.etag ?? ''),
                downloadedAt: Value(DateTime.now()),
                sizeBytes: Value(result.sizeBytes),
              ));
              downloaded++;
            } catch (_) {
              failed++;
            }
            controller.add(SyncProgress(
              status: SyncStatus.running,
              total: total,
              downloaded: downloaded,
              failed: failed,
              currentFile: photo.basename,
            ));
          }
        }

        final workerCount = toDownload.length.clamp(1, _downloadConcurrency);
        Future.wait(List.generate(workerCount, (_) => worker()))
            .then((_) => controller.close())
            .catchError(controller.addError);

        yield* controller.stream;

        // Pruning: rimuovi file non più attesi da questa regola
        for (final entry in toPrune) {
          await _local.deleteCacheEntry(entry.fileId, entry.ruleId, entry.downloadFull);
          final refs = await _local.countRefs(entry.fileId, entry.downloadFull);
          if (refs == 0) {
            final file = File(entry.localPath);
            if (await file.exists()) await file.delete();
          }
        }

        await _local.updateLastSyncedAt(rule.id, DateTime.now());
      }

      yield SyncProgress(
        status: SyncStatus.idle,
        total: total,
        downloaded: downloaded,
        failed: failed,
      );
    } catch (e) {
      yield SyncProgress(
        status: SyncStatus.error,
        total: 0,
        downloaded: 0,
        failed: 0,
        currentFile: e.toString(),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> getLocalPath(int fileId) async {
    try {
      return Right(await _local.getLocalPath(fileId));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Map<int, String>> getLocalPaths(Set<int> fileIds) async {
    try {
      return await _local.getLocalPaths(fileIds);
    } catch (_) {
      return {};
    }
  }

  @override
  Future<Either<Failure, List<String>>> getLocalPhotoPathsForRule(int ruleId) async {
    try {
      final entries = await _local.getCacheEntriesForRule(ruleId);
      // Dedupe by fileId (a photo may be cached as both preview and original).
      final byFileId = <int, String>{};
      for (final e in entries) {
        byFileId.putIfAbsent(e.fileId, () => e.localPath);
      }
      return Right(byFileId.values.toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({int fileCount, int sizeBytes})>> getCacheStatsForRule(int ruleId) async {
    try {
      return Right(await _local.getCacheStatsForRule(ruleId));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalCacheBytes() async {
    try {
      return Right(await _local.getTotalCacheBytes());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<List<Photo>> _getExpectedPhotos(SyncRule rule) async {
    if (rule.type == SyncRuleType.album) {
      final result = await _albums.getAlbumPhotos(rule.clusterId!);
      return result.fold((_) => [], (photos) => photos);
    }

    // S8 — single batch request instead of N sequential getDayPhotos calls.
    final cutoffEpoch =
        DateTime.now().subtract(Duration(days: rule.daysBack!)).millisecondsSinceEpoch ~/
            1000;

    final daysResult = await _timeline.getDays();
    final days = daysResult.fold((_) => <PhotoDay>[], (d) => d);

    // Only fetch days that fall within the requested range.
    final relevantDayIds = days
        .where((d) => d.dayId * 86400 >= cutoffEpoch)
        .map((d) => d.dayId)
        .toList();

    if (relevantDayIds.isEmpty) return [];

    final photosResult = await _timeline.getDaysPhotos(relevantDayIds);
    return photosResult.fold(
      (_) => [],
      (photos) => photos.where((p) => p.epoch >= cutoffEpoch).toList(),
    );
  }
}
