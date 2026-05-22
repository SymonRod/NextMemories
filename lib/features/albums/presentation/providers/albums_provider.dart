import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../../data/repositories/albums_repository_impl.dart';
import '../../domain/entities/album.dart';
import '../../domain/usecases/get_album_photos_use_case.dart';
import '../../domain/usecases/get_albums_use_case.dart';

part 'albums_provider.g.dart';

@riverpod
Future<List<Album>> albums(Ref ref) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  final result = await GetAlbumsUseCase(repo)();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (albums) => albums,
  );
}

@riverpod
Future<List<Photo>> albumPhotos(Ref ref, String clusterId) async {
  ref.keepAlive();
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  final result = await GetAlbumPhotosUseCase(repo)(clusterId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (photos) => photos,
  );
}
