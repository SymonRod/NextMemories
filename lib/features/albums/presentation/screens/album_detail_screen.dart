import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/memories_api.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../timeline/domain/entities/photo.dart';
import '../../../timeline/presentation/providers/selection_provider.dart';
import '../providers/albums_provider.dart';
import '../widgets/album_picker_sheet.dart';

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
    final selection = ref.watch(selectionProvider);

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
          final httpHeaders = {'Authorization': 'Basic $credentials'};
          final inSelectionMode = selection.isNotEmpty;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: inSelectionMode
                    ? Text('${selection.length} selezionate')
                    : Text(albumName),
                floating: true,
                snap: true,
                actions: [
                  if (inSelectionMode)
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Annulla selezione',
                      onPressed: () =>
                          ref.read(selectionProvider.notifier).state = const {},
                    ),
                ],
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
                    (context, index) => _AlbumPhotoTile(
                      photo: photos[index],
                      clusterId: clusterId,
                      albumName: albumName,
                      index: index,
                      serverUrl: config.serverUrl,
                      httpHeaders: httpHeaders,
                    ),
                    childCount: photos.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
      bottomNavigationBar: selection.isNotEmpty
          ? _SelectionBar(
              selection: selection,
              clusterId: clusterId,
              albumName: albumName,
              allPhotos: photosAsync.valueOrNull ?? const [],
            )
          : null,
    );
  }
}

class _SelectionBar extends ConsumerWidget {
  final Set<int> selection;
  final String clusterId;
  final String albumName;
  final List<Photo> allPhotos;

  const _SelectionBar({
    required this.selection,
    required this.clusterId,
    required this.albumName,
    required this.allPhotos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Text(
              '${selection.length} selezionate',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Aggiungi ad altro album',
              icon: const Icon(Icons.add_to_photos_outlined),
              onPressed: () => _pickAlbum(context, ref),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _removeFromAlbum(context, ref),
              icon: const Icon(Icons.remove_circle_outline, size: 18),
              label: const Text('Rimuovi dall\'album'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFromAlbum(BuildContext context, WidgetRef ref) {
    final fileIdToBasename = {
      for (final photo in allPhotos)
        if (selection.contains(photo.fileId)) photo.fileId: photo.basename,
    };
    // Capture notifiers before clearing selection — clearing disposes this widget and its ref.
    final removeNotifier = ref.read(removePhotosFromAlbumProvider.notifier);
    final selectionNotifier = ref.read(selectionProvider.notifier);
    selectionNotifier.state = const {};
    removeNotifier.remove(albumName, clusterId, fileIdToBasename);
  }

  void _pickAlbum(BuildContext context, WidgetRef ref) {
    showAlbumPickerSheet(
      context,
      onAlbumSelected: (album) async {
        final fileIds = selection.toList();
        // Capture notifiers before clearing selection — clearing disposes this widget and its ref.
        final addNotifier = ref.read(addPhotosToAlbumProvider.notifier);
        final selectionNotifier = ref.read(selectionProvider.notifier);
        selectionNotifier.state = const {};
        await addNotifier.add(album.name, fileIds);
      },
    );
  }
}

class _AlbumPhotoTile extends ConsumerWidget {
  final Photo photo;
  final String clusterId;
  final String albumName;
  final int index;
  final String serverUrl;
  final Map<String, String> httpHeaders;

  const _AlbumPhotoTile({
    required this.photo,
    required this.clusterId,
    required this.albumName,
    required this.index,
    required this.serverUrl,
    required this.httpHeaders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    final isSelected = selection.contains(photo.fileId);
    final inSelectionMode = selection.isNotEmpty;

    final Widget imageWidget;
    if (photo.localPath != null) {
      imageWidget = Image.file(
        File(photo.localPath!),
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(Icons.broken_image_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer, size: 24),
        ),
      );
    } else {
      final url =
          '$serverUrl${MemoriesApi.photoPreview(photo.fileId, etag: photo.etag ?? '', x: 256, y: 256)}';
      imageWidget = CachedNetworkImage(
        imageUrl: url,
        httpHeaders: httpHeaders,
        fit: BoxFit.cover,
        memCacheWidth: 256,
        memCacheHeight: 256,
        placeholder: (ctx, url) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest),
        errorWidget: (ctx, url, err) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(Icons.broken_image_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer, size: 24),
        ),
      );
    }

    return GestureDetector(
      onLongPress: () {
        ref.read(selectionProvider.notifier).update(
              (s) => {...s, photo.fileId},
            );
      },
      onTap: () {
        if (inSelectionMode) {
          ref.read(selectionProvider.notifier).update(
                (s) => isSelected
                    ? s.difference({photo.fileId})
                    : {...s, photo.fileId},
              );
        } else {
          context.push(
            '/album-viewer',
            extra: {
              'clusterId': clusterId,
              'albumName': albumName,
              'index': index,
            },
          );
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          if (inSelectionMode)
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
          if (inSelectionMode)
            Positioned(
              top: 4,
              left: 4,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isSelected
                    ? Icon(
                        Icons.check_circle,
                        key: const ValueKey('checked'),
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black38),
                        ],
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        key: const ValueKey('unchecked'),
                        color: Colors.white,
                        size: 22,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black54),
                        ],
                      ),
              ),
            ),
        ],
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
