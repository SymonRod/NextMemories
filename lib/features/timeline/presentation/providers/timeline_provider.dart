import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/timeline_repository_impl.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_day.dart';
import '../../domain/usecases/get_day_photos_use_case.dart';
import '../../domain/usecases/get_timeline_days_use_case.dart';

part 'timeline_provider.g.dart';

@riverpod
Future<List<PhotoDay>> timelineDays(Ref ref) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = TimelineRepositoryImpl.fromConfig(config);
  final result = await GetTimelineDaysUseCase(repo)();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (days) => days,
  );
}

@riverpod
Future<List<Photo>> dayPhotos(Ref ref, int dayId) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = TimelineRepositoryImpl.fromConfig(config);
  final result = await GetDayPhotosUseCase(repo)(dayId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (photos) => photos,
  );
}
