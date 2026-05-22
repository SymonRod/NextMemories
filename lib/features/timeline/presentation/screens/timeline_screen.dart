import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_day.dart';
import '../providers/timeline_provider.dart';
import '../../../../core/api/memories_api.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(timelineDaysProvider);

    return Scaffold(
      body: daysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString(), onRetry: () => ref.invalidate(timelineDaysProvider)),
        data: (days) => days.isEmpty
            ? const _EmptyView()
            : _TimelineList(days: days),
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  final List<PhotoDay> days;
  const _TimelineList({required this.days});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Timeline'),
          floating: true,
          snap: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _DaySection(day: days[index]),
            childCount: days.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class _DaySection extends ConsumerWidget {
  final PhotoDay day;
  const _DaySection({required this.day});

  static const _months = [
    '', 'gennaio', 'febbraio', 'marzo', 'aprile', 'maggio', 'giugno',
    'luglio', 'agosto', 'settembre', 'ottobre', 'novembre', 'dicembre',
  ];

  String _formatDayId(int dayId) {
    final date = DateTime.fromMillisecondsSinceEpoch(dayId * 86400 * 1000, isUtc: true);
    return '${date.day} ${_months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(dayPhotosProvider(day.dayId));

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
        photosAsync.when(
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, _) => SizedBox(
            height: 48,
            child: Center(
              child: Text(
                'Errore caricamento',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
          data: (photos) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) => _PhotoTile(
              photo: photos[index],
              dayId: day.dayId,
              index: index,
            ),
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
  const _PhotoTile({required this.photo, required this.dayId, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(authProvider).valueOrNull;
    if (config == null) return const SizedBox.shrink();

    final credentials = base64Encode(
      utf8.encode('${config.username}:${config.appPassword}'),
    );
    final url = '${config.serverUrl}${MemoriesApi.photoPreview(
      photo.fileId,
      etag: photo.etag ?? '',
      x: 512,
      y: 512,
    )}';

    return GestureDetector(
      onTap: () => context.push('/viewer?dayId=$dayId&index=$index'),
      child: CachedNetworkImage(
      imageUrl: url,
      httpHeaders: {'Authorization': 'Basic $credentials'},
      fit: BoxFit.cover,
      placeholder: (context2, url) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context2, url, err) => Container(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Icon(
          Icons.broken_image_rounded,
          color: Theme.of(context).colorScheme.onErrorContainer,
          size: 24,
        ),
      ),
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
