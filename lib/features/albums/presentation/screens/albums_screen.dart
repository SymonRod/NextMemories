import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/memories_api.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/album.dart';
import '../providers/albums_provider.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);

    return Scaffold(
      body: albumsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(albumsProvider),
        ),
        data: (albums) => albums.isEmpty
            ? const _EmptyView()
            : _AlbumsGrid(albums: albums),
      ),
    );
  }
}

class _AlbumsGrid extends ConsumerWidget {
  final List<Album> albums;
  const _AlbumsGrid({required this.albums});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(authProvider).valueOrNull;
    if (config == null) return const SizedBox.shrink();

    final credentials = base64Encode(
      utf8.encode('${config.username}:${config.appPassword}'),
    );

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Album'),
          floating: true,
          snap: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _AlbumCard(
                album: albums[index],
                credentials: credentials,
                serverUrl: config.serverUrl,
              ),
              childCount: albums.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final Album album;
  final String credentials;
  final String serverUrl;
  const _AlbumCard({
    required this.album,
    required this.credentials,
    required this.serverUrl,
  });

  @override
  Widget build(BuildContext context) {
    final coverUrl = '$serverUrl${MemoriesApi.photoPreview(
      album.lastAddedPhoto,
      etag: album.lastAddedPhotoEtag ?? '',
      x: 512,
      y: 512,
    )}';

    return GestureDetector(
      onTap: () => context.push(
        '/album-detail',
        extra: {'clusterId': album.clusterId, 'name': album.name},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                httpHeaders: {'Authorization': 'Basic $credentials'},
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (context, url, err) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.photo_album_outlined,
                    color: Theme.of(context).colorScheme.outlineVariant,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            album.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${album.count} foto',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_album_outlined,
              size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text('Nessun album trovato',
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              message.replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}
