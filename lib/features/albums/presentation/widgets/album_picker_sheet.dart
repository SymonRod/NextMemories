import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/memories_api.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/album.dart';
import '../providers/albums_provider.dart';

/// Shows a bottom sheet with album list; calls [onAlbumSelected] when an album is tapped.
Future<void> showAlbumPickerSheet(
  BuildContext context, {
  required void Function(Album album) onAlbumSelected,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _AlbumPickerSheet(onAlbumSelected: onAlbumSelected),
  );
}

class _AlbumPickerSheet extends ConsumerWidget {
  final void Function(Album album) onAlbumSelected;
  const _AlbumPickerSheet({required this.onAlbumSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final config = ref.watch(authProvider).valueOrNull;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Aggiungi ad album',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: albumsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (albums) => ListView.builder(
                controller: controller,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  final coverUrl = config != null
                      ? '${config.serverUrl}${MemoriesApi.photoPreview(
                          album.lastAddedPhoto,
                          etag: album.lastAddedPhotoEtag ?? '',
                          x: 128,
                          y: 128,
                        )}'
                      : '';
                  final credentials = config != null
                      ? base64Encode(utf8.encode(
                          '${config.username}:${config.appPassword}'))
                      : '';

                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: config != null
                            ? CachedNetworkImage(
                                imageUrl: coverUrl,
                                httpHeaders: {
                                  'Authorization': 'Basic $credentials'
                                },
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) => Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                ),
                                errorWidget: (ctx, url, err) => Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  child: Icon(
                                    Icons.photo_album_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                  ),
                                ),
                              )
                            : Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                              ),
                      ),
                    ),
                    title: Text(album.name),
                    subtitle: Text('${album.count} foto'),
                    onTap: () {
                      Navigator.of(context).pop();
                      onAlbumSelected(album);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
