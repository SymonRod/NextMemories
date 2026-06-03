import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:share_plus/share_plus.dart';

import '../../../../core/api/memories_api.dart';
import '../../../../core/services/share_service.dart';
import '../../../albums/domain/entities/album.dart';
import '../../../albums/presentation/providers/albums_provider.dart';
import '../../../albums/presentation/widgets/album_picker_sheet.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_day.dart';
import '../providers/selection_provider.dart';
import '../providers/timeline_provider.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineProvider);
    final selection = ref.watch(selectionProvider);

    return Scaffold(
      body: timelineAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(timelineProvider),
        ),
        data: (data) => data.days.isEmpty
            ? const _EmptyView()
            : _TimelineList(days: data.days, photosByDay: data.photosByDay),
      ),
      bottomNavigationBar: selection.isNotEmpty
          ? _SelectionBar(selection: selection)
          : null,
    );
  }
}

class _SelectionBar extends ConsumerWidget {
  final Set<int> selection;
  const _SelectionBar({required this.selection});

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
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Condividi',
              onPressed: () => _share(context, ref),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _pickAlbum(context, ref),
              icon: const Icon(Icons.photo_album_outlined, size: 18),
              label: const Text('Aggiungi ad album'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final useOriginal = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Qualità condivisione'),
        content: const Text(
          'Vuoi condividere le foto originali (alta qualità) o come anteprime?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Anteprima'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Originale'),
          ),
        ],
      ),
    );
    if (useOriginal == null || !context.mounted) return;

    final timelineData = ref.read(timelineProvider).valueOrNull;
    final selectedPhotos = timelineData?.photosByDay.values
            .expand((l) => l)
            .where((p) => selection.contains(p.fileId))
            .toList() ??
        [];
    if (selectedPhotos.isEmpty) return;

    final config = ref.read(authProvider).valueOrNull;
    if (config == null) return;

    final authHeader =
        'Basic ${base64Encode(utf8.encode('${config.username}:${config.appPassword}'))}';

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Preparazione...'),
          ],
        ),
      ),
    );

    List<XFile>? xFiles;
    try {
      xFiles = await ShareService.prepareFiles(
        photos: selectedPhotos,
        useOriginal: useOriginal,
        serverUrl: config.serverUrl,
        authHeader: authHeader,
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    // Close loading dialog before opening share sheet — avoids black screen
    // on return and GoRouter navigator stack corruption.
    Navigator.of(context, rootNavigator: true).pop();

    await Share.shareXFiles(xFiles);
  }

  void _pickAlbum(BuildContext context, WidgetRef ref) {
    showAlbumPickerSheet(
      context,
      onAlbumSelected: (Album album) async {
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

class _TimelineList extends ConsumerWidget {
  final List<PhotoDay> days;
  final Map<int, List<Photo>> photosByDay;
  const _TimelineList({required this.days, required this.photosByDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(authProvider).valueOrNull;
    final headers = config != null
        ? {
            'Authorization': 'Basic ${base64Encode(utf8.encode('${config.username}:${config.appPassword}'))}'
          }
        : <String, String>{};

    final selection = ref.watch(selectionProvider);
    final inSelectionMode = selection.isNotEmpty;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: inSelectionMode
              ? Text('${selection.length} selezionate')
              : const Text('Timeline'),
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _DaySection(
              day: days[index],
              photos: photosByDay[days[index].dayId],
              serverUrl: config?.serverUrl ?? '',
              httpHeaders: headers,
            ),
            childCount: days.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  final PhotoDay day;
  final List<Photo>? photos;
  final String serverUrl;
  final Map<String, String> httpHeaders;

  const _DaySection({
    required this.day,
    required this.photos,
    required this.serverUrl,
    required this.httpHeaders,
  });

  static const _months = [
    '', 'gennaio', 'febbraio', 'marzo', 'aprile', 'maggio', 'giugno',
    'luglio', 'agosto', 'settembre', 'ottobre', 'novembre', 'dicembre',
  ];

  String _formatDayId(int dayId) {
    final date = DateTime.fromMillisecondsSinceEpoch(dayId * 86400 * 1000, isUtc: true);
    return '${date.day} ${_months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dayPhotos = photos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            _formatDayId(day.dayId),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        if (dayPhotos == null)
          const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: dayPhotos.length,
            itemBuilder: (context, index) => _PhotoTile(
              photo: dayPhotos[index],
              dayId: day.dayId,
              index: index,
              serverUrl: serverUrl,
              httpHeaders: httpHeaders,
            ),
          ),
      ],
    );
  }
}

class _PhotoTile extends ConsumerWidget {
  final Photo photo;
  final int dayId;
  final int index;
  final String serverUrl;
  final Map<String, String> httpHeaders;

  const _PhotoTile({
    required this.photo,
    required this.dayId,
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
        cacheWidth: 256,
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
          context.push('/viewer?dayId=$dayId&index=$index');
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
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_library_outlined,
              size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text('Nessuna foto trovata',
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
