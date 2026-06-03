import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/photo_metadata_cache.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../sync/presentation/providers/sync_rules_provider.dart';
import '../../data/repositories/timeline_repository_impl.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/i_timeline_repository.dart';
import '../../domain/usecases/get_day_photos_use_case.dart';

part 'timeline_provider.g.dart';

final _metadataCache = PhotoMetadataCache();

// T1 — shared repository; Dio is late final inside the datasource,
// so one instance here means connection reuse across all timeline calls.
@Riverpod(keepAlive: true)
TimelineRepositoryImpl timelineRepository(Ref ref) {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  return TimelineRepositoryImpl.fromConfig(config);
}

// Cache-first timeline: emits the last-known days+photos from the Hive cache
// immediately (so reopening the app is instant), then revalidates from the
// network in the background and re-emits only the fresh data.
//
// T1+T2 — a single GET /days (with inline detail) feeds both the day list and
// the photos map; T3 — all local paths are resolved in one DB query;
// T4 — keepAlive avoids refetching on every navigation back to the timeline.
@Riverpod(keepAlive: true)
Stream<TimelineData> timeline(Ref ref) async* {
  final config = ref.watch(authProvider).valueOrNull;

  // 1. Stale: show the last-known timeline from cache without waiting on network.
  final cachedDays = await _metadataCache.getDays();
  if (cachedDays != null && cachedDays.isNotEmpty) {
    final cachedPhotos = <int, List<Photo>>{};
    for (final day in cachedDays) {
      final photos = await _metadataCache.getPhotosForDay(day.dayId);
      if (photos != null) cachedPhotos[day.dayId] = photos;
    }
    final enriched = await _enrichAllWithLocalPaths(ref, cachedPhotos);
    yield (days: cachedDays, photosByDay: enriched);
  }

  // Without auth we cannot revalidate: keep the cache if present, else fail.
  if (config == null) {
    if (cachedDays != null && cachedDays.isNotEmpty) return;
    throw Exception('Not authenticated');
  }

  // 2. Revalidate: one network round-trip yields both days and photos.
  final repo = ref.watch(timelineRepositoryProvider);
  final result = await repo.getTimeline();
  yield* result.fold(
    (failure) async* {
      // Network down: stay on the stale cache if we already emitted it.
      if (cachedDays == null || cachedDays.isEmpty) {
        throw Exception(failure.message);
      }
    },
    (data) async* {
      await _metadataCache.saveDays(data.days);
      for (final entry in data.photosByDay.entries) {
        await _metadataCache.savePhotosForDay(entry.key, entry.value);
      }
      final enriched = await _enrichAllWithLocalPaths(ref, data.photosByDay);
      yield (days: data.days, photosByDay: enriched);
    },
  );
}

// T3 — single DB query for all file IDs instead of one per photo.
Future<Map<int, List<Photo>>> _enrichAllWithLocalPaths(
  Ref ref,
  Map<int, List<Photo>> byDay,
) async {
  try {
    final syncRepo = ref.read(syncRepositoryProvider);
    final allFileIds = byDay.values.expand((l) => l).map((p) => p.fileId).toSet();
    final localPaths = await syncRepo.getLocalPaths(allFileIds);
    if (localPaths.isEmpty) return byDay;

    return {
      for (final entry in byDay.entries)
        entry.key: entry.value.map((p) {
          final path = localPaths[p.fileId];
          return path != null ? p.copyWith(localPath: path) : p;
        }).toList(),
    };
  } catch (_) {
    return byDay;
  }
}

// Single-day provider used by the viewer (deep-link / direct access).
// Prefers the already-loaded timeline map; only hits the network as a fallback.
@riverpod
Future<List<Photo>> dayPhotos(Ref ref, int dayId) async {
  final fromMap = ref.watch(timelineProvider).valueOrNull?.photosByDay[dayId];
  if (fromMap != null) return fromMap;

  final repo = ref.watch(timelineRepositoryProvider);
  final result = await GetDayPhotosUseCase(repo)(dayId);
  final photos = await result.fold(
    (failure) async {
      final cached = await _metadataCache.getPhotosForDay(dayId);
      if (cached != null) return cached;
      throw Exception(failure.message);
    },
    (photos) async {
      await _metadataCache.savePhotosForDay(dayId, photos);
      return photos;
    },
  );

  // T3 — batch enrich even for the fallback single-day path.
  try {
    final syncRepo = ref.read(syncRepositoryProvider);
    final ids = photos.map((p) => p.fileId).toSet();
    final localPaths = await syncRepo.getLocalPaths(ids);
    if (localPaths.isEmpty) return photos;
    return photos.map((p) {
      final path = localPaths[p.fileId];
      return path != null ? p.copyWith(localPath: path) : p;
    }).toList();
  } catch (_) {
    return photos;
  }
}
