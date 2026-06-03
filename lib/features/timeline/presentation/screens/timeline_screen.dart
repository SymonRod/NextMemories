import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/memories_api.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_day.dart';
import '../providers/timeline_provider.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineProvider);

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
    );
  }
}

class _TimelineList extends ConsumerWidget {
  final List<PhotoDay> days;
  final Map<int, List<Photo>> photosByDay;
  const _TimelineList({required this.days, required this.photosByDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // T5 — compute credentials once per list build, not per tile.
    final config = ref.watch(authProvider).valueOrNull;
    final headers = config != null
        ? {
            'Authorization': 'Basic ${base64Encode(utf8.encode('${config.username}:${config.appPassword}'))}'
          }
        : <String, String>{};

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Timeline'),
          floating: true,
          snap: true,
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

class _PhotoTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final Widget imageWidget;
    if (photo.localPath != null) {
      imageWidget = Image.file(
        File(photo.localPath!),
        fit: BoxFit.cover,
        cacheWidth: 256,
        errorBuilder: (_, __, ___) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(Icons.broken_image_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer, size: 24),
        ),
      );
    } else {
      // T5 — 256px covers typical 3-column grid tiles at up to 2× dpr;
      //      headers are computed once by _TimelineList, not per-build.
      final url =
          '$serverUrl${MemoriesApi.photoPreview(photo.fileId, etag: photo.etag ?? '', x: 256, y: 256)}';
      imageWidget = CachedNetworkImage(
        imageUrl: url,
        httpHeaders: httpHeaders,
        fit: BoxFit.cover,
        memCacheWidth: 256,
        memCacheHeight: 256,
        placeholder: (_, __) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest),
        errorWidget: (_, __, ___) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(Icons.broken_image_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer, size: 24),
        ),
      );
    }

    return GestureDetector(
      onTap: () => context.push('/viewer?dayId=$dayId&index=$index'),
      child: imageWidget,
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
