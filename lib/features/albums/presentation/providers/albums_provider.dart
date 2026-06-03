import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/photo_metadata_cache.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/sync/presentation/providers/sync_rules_provider.dart';
import '../../../../features/timeline/domain/entities/photo.dart';
import '../../data/repositories/albums_repository_impl.dart';
import '../../domain/entities/album.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/usecases/add_photos_to_album_use_case.dart';
import '../../domain/usecases/create_album_use_case.dart';
import '../../domain/usecases/delete_album_use_case.dart';
import '../../domain/usecases/get_album_photos_use_case.dart';
import '../../domain/usecases/get_albums_use_case.dart';
import '../../domain/usecases/remove_photos_from_album_use_case.dart';

part 'albums_provider.g.dart';

final _albumMetadataCache = PhotoMetadataCache();

@riverpod
Stream<List<Album>> albums(Ref ref) async* {
  final config = ref.watch(authProvider).valueOrNull;

  // 1. Stale: mostra subito la cache locale, se presente (nessuna attesa di rete).
  final cached = await _albumMetadataCache.getAlbums();
  if (cached != null) yield cached;

  // Senza auth non possiamo rivalidare: teniamo la cache se c'è, altrimenti errore.
  if (config == null) {
    if (cached != null) return;
    throw Exception('Not authenticated');
  }

  // 2. Revalidate: interroga il server in background e aggiorna solo se cambia qualcosa.
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  final result = await GetAlbumsUseCase(repo)();
  yield* result.fold(
    (failure) async* {
      // Server non raggiungibile: se abbiamo già mostrato la cache, restiamo su quella.
      if (cached == null) throw Exception(failure.message);
    },
    (fresh) async* {
      await _albumMetadataCache.saveAlbums(fresh);
      unawaited(_prefetchAllAlbumPhotos(config, fresh));
      // Evita un rebuild inutile (e il flicker delle cover) se nulla è cambiato.
      if (!listEquals(cached, fresh)) yield fresh;
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
Stream<List<Photo>> albumPhotos(Ref ref, String clusterId) async* {
  ref.keepAlive();
  final config = ref.watch(authProvider).valueOrNull;

  // 1. Stale: mostra subito le foto in cache (arricchite con i path locali).
  final cached = await _albumMetadataCache.getPhotosForAlbum(clusterId);
  if (cached != null) yield await _withLocalPaths(ref, cached);

  if (config == null) {
    if (cached != null) return;
    throw Exception('Not authenticated');
  }

  // 2. Revalidate: aggiorna dal server e ri-emetti solo se la lista è cambiata.
  final repo = AlbumsRepositoryImpl.fromConfig(config);
  final result = await GetAlbumPhotosUseCase(repo)(clusterId);
  yield* result.fold(
    (failure) async* {
      if (cached == null) throw Exception(failure.message);
    },
    (fresh) async* {
      await _albumMetadataCache.savePhotosForAlbum(clusterId, fresh);
      if (!listEquals(cached, fresh)) yield await _withLocalPaths(ref, fresh);
    },
  );
}

@riverpod
class RemovePhotosFromAlbum extends _$RemovePhotosFromAlbum {
  @override
  Future<void> build() async {}

  Future<void> remove(
    String albumName,
    String clusterId,
    Map<int, String> fileIdToBasename,
  ) async {
    final config = ref.read(authProvider).valueOrNull;
    if (config == null) throw Exception('Not authenticated');
    final notifications = ref.read(notificationServiceProvider);
    final count = fileIdToBasename.length;
    notifications.showInfo('Rimozione di $count foto…');
    state = const AsyncLoading();
    final repo = AlbumsRepositoryImpl.fromConfig(config);
    final result =
        await RemovePhotosFromAlbumUseCase(repo)(albumName, fileIdToBasename);
    state = result.fold(
      (f) {
        notifications.showError(f.message);
        return AsyncError(f.message, StackTrace.current);
      },
      (_) {
        ref.invalidate(albumPhotosProvider(clusterId));
        notifications.showSuccess(
          '${count == 1 ? '1 foto rimossa' : '$count foto rimosse'} da "$albumName"',
        );
        return const AsyncData(null);
      },
    );
  }
}

@riverpod
class AddPhotosToAlbum extends _$AddPhotosToAlbum {
  @override
  Future<void> build() async {}

  Future<void> add(String albumName, List<int> fileIds) async {
    final config = ref.read(authProvider).valueOrNull;
    if (config == null) throw Exception('Not authenticated');
    final notifications = ref.read(notificationServiceProvider);
    notifications.showInfo('Aggiungendo ${fileIds.length} foto…');
    state = const AsyncLoading();
    final repo = AlbumsRepositoryImpl.fromConfig(config);
    final result = await AddPhotosToAlbumUseCase(repo)(albumName, fileIds);
    state = result.fold(
      (f) {
        notifications.showError(f.message);
        return AsyncError(f.message, StackTrace.current);
      },
      (_) {
        notifications.showSuccess(
          '${fileIds.length} ${fileIds.length == 1 ? 'foto aggiunta' : 'foto aggiunte'} a "$albumName"',
        );
        return const AsyncData(null);
      },
    );
  }
}

@riverpod
class DeleteAlbum extends _$DeleteAlbum {
  @override
  Future<void> build() async {}

  Future<void> delete(String albumName) async {
    final config = ref.read(authProvider).valueOrNull;
    if (config == null) throw Exception('Not authenticated');
    final notifications = ref.read(notificationServiceProvider);
    state = const AsyncLoading();
    final repo = AlbumsRepositoryImpl.fromConfig(config);
    final result = await DeleteAlbumUseCase(repo)(albumName);
    state = result.fold(
      (f) {
        notifications.showError(f.message);
        return AsyncError(f.message, StackTrace.current);
      },
      (_) {
        ref.invalidate(albumsProvider);
        notifications.showSuccess('Album "$albumName" eliminato');
        return const AsyncData(null);
      },
    );
  }
}

@riverpod
class CreateAlbum extends _$CreateAlbum {
  @override
  Future<void> build() async {}

  Future<void> create(String albumName) async {
    final config = ref.read(authProvider).valueOrNull;
    if (config == null) throw Exception('Not authenticated');
    final notifications = ref.read(notificationServiceProvider);
    state = const AsyncLoading();
    final repo = AlbumsRepositoryImpl.fromConfig(config);
    final result = await CreateAlbumUseCase(repo)(albumName);
    state = result.fold(
      (f) {
        notifications.showError(f.message);
        return AsyncError(f.message, StackTrace.current);
      },
      (_) {
        ref.invalidate(albumsProvider);
        notifications.showSuccess('Album "$albumName" creato');
        return const AsyncData(null);
      },
    );
  }
}

// Arricchisce le foto con il path locale del file scaricato in cache, se presente.
// T3 — una sola query DB (WHERE fileId IN ...) invece di una per foto.
Future<List<Photo>> _withLocalPaths(Ref ref, List<Photo> photos) async {
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
