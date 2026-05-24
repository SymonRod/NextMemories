// ignore_for_file: prefer_initializing_formals
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/error/failures.dart';
import '../../../albums/domain/repositories/i_albums_repository.dart';
import '../../../timeline/domain/entities/photo.dart';
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

        for (final photo in toDownload) {
          yield SyncProgress(
            status: SyncStatus.running,
            total: total,
            downloaded: downloaded,
            failed: failed,
            currentFile: photo.basename,
          );

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

          yield SyncProgress(
            status: SyncStatus.running,
            total: total,
            downloaded: downloaded,
            failed: failed,
          );
        }

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

    // time_range: recupera tutte le giornate e filtra per epoch
    final daysResult = await _timeline.getDays();
    final days = daysResult.fold((_) => [], (d) => d);
    final cutoffEpoch =
        DateTime.now().subtract(Duration(days: rule.daysBack!)).millisecondsSinceEpoch ~/
            1000;

    final allPhotos = <Photo>[];
    for (final day in days) {
      final photosResult = await _timeline.getDayPhotos(day.dayId);
      photosResult.fold(
        (_) {},
        (photos) => allPhotos.addAll(photos.where((p) => p.epoch >= cutoffEpoch)),
      );
    }
    return allPhotos;
  }
}
