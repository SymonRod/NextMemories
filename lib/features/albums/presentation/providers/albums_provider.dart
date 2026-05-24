import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/photo_metadata_cache.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/sync/presentation/providers/sync_rules_provider.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../../data/repositories/albums_repository_impl.dart';
import '../../domain/entities/album.dart';
import '../../domain/usecases/get_album_photos_use_case.dart';
import '../../domain/usecases/get_albums_use_case.dart';

part 'albums_provider.g.dart';

final _albumMetadataCache = PhotoMetadataCache();

@riverpod
Future<List<Album>> albums(Ref ref) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  final result = await GetAlbumsUseCase(repo)();
  return result.fold(
    (failure) async {
      final cached = await _albumMetadataCache.getAlbums();
      if (cached != null) return cached;
      throw Exception(failure.message);
    },
    (albums) async {
      await _albumMetadataCache.saveAlbums(albums);
      unawaited(_prefetchAllAlbumPhotos(config, albums));
      return albums;
    },
  );
}

// Prefetch foto di tutti gli album in background (solo quelli non ancora in cache).
Future<void> _prefetchAllAlbumPhotos(ServerConfig config, List<Album> albums) async {
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  await Future.wait(
    albums.map((album) async {
      if (await _albumMetadataCache.getPhotosForAlbum(album.clusterId) != null) return;
      try {
        final result = await GetAlbumPhotosUseCase(repo)(album.clusterId);
        await result.fold(
          (_) async {},
          (photos) => _albumMetadataCache.savePhotosForAlbum(album.clusterId, photos),
        );
      } catch (_) {}
    }),
  );
}

@riverpod
Future<List<Photo>> albumPhotos(Ref ref, String clusterId) async {
  ref.keepAlive();
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  final result = await GetAlbumPhotosUseCase(repo)(clusterId);
  final photos = await result.fold(
    (failure) async {
      final cached = await _albumMetadataCache.getPhotosForAlbum(clusterId);
      if (cached != null) return cached;
      throw Exception(failure.message);
    },
    (photos) async {
      await _albumMetadataCache.savePhotosForAlbum(clusterId, photos);
      return photos;
    },
  );
  try {
    final syncRepo = ref.read(syncRepositoryProvider);
    return await Future.wait(photos.map((p) async {
      final r = await syncRepo.getLocalPath(p.fileId);
      final path = r.fold((_) => null, (v) => v);
      return path != null ? p.copyWith(localPath: path) : p;
    }));
  } catch (_) {
    return photos;
  }
}
