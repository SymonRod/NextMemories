import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/memories_api.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/albums_provider.dart';

class AlbumDetailScreen extends ConsumerWidget {
  final String clusterId;
  final String albumName;

  const AlbumDetailScreen({
    super.key,
    required this.clusterId,
    required this.albumName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(albumPhotosProvider(clusterId));
    final config = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          albumName: albumName,
          onRetry: () => ref.invalidate(albumPhotosProvider(clusterId)),
        ),
        data: (photos) {
          if (config == null || photos.isEmpty) {
            return _EmptyBody(albumName: albumName);
          }

          final credentials = base64Encode(
            utf8.encode('${config.username}:${config.appPassword}'),
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(albumName),
                floating: true,
                snap: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(2),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final photo = photos[index];
                      final url =
                          '${config.serverUrl}${MemoriesApi.photoPreview(
                        photo.fileId,
                        etag: photo.etag ?? '',
                        x: 512,
                        y: 512,
                      )}';

                      return GestureDetector(
                        onTap: () => context.push(
                          '/album-viewer',
                          extra: {
                            'clusterId': clusterId,
                            'albumName': albumName,
                            'index': index,
                          },
                        ),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          httpHeaders: {'Authorization': 'Basic $credentials'},
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                          errorWidget: (context, url, err) => Container(
                            color:
                                Theme.of(context).colorScheme.errorContainer,
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: photos.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  final String albumName;
  const _EmptyBody({required this.albumName});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: Text(albumName), floating: true, snap: true),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 16),
                Text('Nessuna foto in questo album',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final String albumName;
  final VoidCallback onRetry;
  const _ErrorBody(
      {required this.message, required this.albumName, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: Text(albumName), floating: true, snap: true),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.outlineVariant),
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
          ),
        ),
      ],
    );
  }
}
