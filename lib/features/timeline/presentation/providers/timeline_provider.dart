import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/photo_metadata_cache.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../sync/presentation/providers/sync_rules_provider.dart';
import '../../data/repositories/timeline_repository_impl.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_day.dart';
import '../../domain/usecases/get_day_photos_use_case.dart';
import '../../domain/usecases/get_timeline_days_use_case.dart';

part 'timeline_provider.g.dart';

final _metadataCache = PhotoMetadataCache();

@riverpod
Future<List<PhotoDay>> timelineDays(Ref ref) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = TimelineRepositoryImpl.fromConfig(config);
  final result = await GetTimelineDaysUseCase(repo)();
  return result.fold(
    (failure) async {
      final cached = await _metadataCache.getDays();
      if (cached != null) return cached;
      throw Exception(failure.message);
    },
    (days) async {
      await _metadataCache.saveDays(days);
      return days;
    },
  );
}

@riverpod
Future<List<Photo>> dayPhotos(Ref ref, int dayId) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = TimelineRepositoryImpl.fromConfig(config);
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
  return _enrichWithLocalPaths(ref, photos);
}

Future<List<Photo>> _enrichWithLocalPaths(Ref ref, List<Photo> photos) async {
  try {
    final syncRepo = ref.read(syncRepositoryProvider);
    return await Future.wait(photos.map((p) async {
      final result = await syncRepo.getLocalPath(p.fileId);
      final path = result.fold((_) => null, (v) => v);
      return path != null ? p.copyWith(localPath: path) : p;
    }));
  } catch (_) {
    return photos;
  }
}
