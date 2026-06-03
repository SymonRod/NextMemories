import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../albums/presentation/providers/albums_provider.dart';
import '../../domain/entities/sync_rule.dart';
import '../../domain/entities/sync_status.dart';
import '../providers/sync_progress_provider.dart';
import '../providers/sync_rules_provider.dart';

class SyncSettingsScreen extends ConsumerWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(syncRulesProvider);
    final progress = ref.watch(syncProgressNotifierProvider);
    final isRunning = progress.status == SyncStatus.running;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronizzazione offline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Aggiungi regola',
            onPressed: isRunning ? null : () => _showAddSheet(context),
          ),
        ],
      ),
      body: rulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(syncRulesProvider),
        ),
        data: (rules) => _RulesBody(rules: rules, progress: progress, isRunning: isRunning),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: isRunning
                ? null
                : () => ref.read(syncProgressNotifierProvider.notifier).startSync(),
            icon: const Icon(Icons.sync_rounded),
            label: Text(isRunning ? 'Sincronizzazione in corso...' : 'Sincronizza ora'),
          ),
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddRuleSheet(),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _RulesBody extends StatelessWidget {
  final List<SyncRule> rules;
  final SyncProgress progress;
  final bool isRunning;

  const _RulesBody({
    required this.rules,
    required this.progress,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      children: [
        if (isRunning) ...[
          _ProgressBanner(progress: progress),
          const SizedBox(height: 8),
        ],
        if (rules.isEmpty)
          const _EmptyRules()
        else
          ...rules.map((rule) => _SyncRuleCard(rule: rule)),
        const SizedBox(height: 16),
        const _TotalCacheCard(),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Progress banner
// ---------------------------------------------------------------------------

class _ProgressBanner extends StatelessWidget {
  final SyncProgress progress;
  const _ProgressBanner({required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = progress.total > 0 ? progress.downloaded / progress.total : null;
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Sincronizzazione in corso...',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: colors.onPrimaryContainer),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: pct,
              borderRadius: BorderRadius.circular(4),
              color: colors.onPrimaryContainer,
              backgroundColor: colors.primary.withAlpha(60),
            ),
            const SizedBox(height: 4),
            Text(
              '${progress.downloaded} / ${progress.total}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.onPrimaryContainer),
            ),
            if (progress.currentFile != null)
              Text(
                progress.currentFile!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.onPrimaryContainer),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rule card
// ---------------------------------------------------------------------------

class _SyncRuleCard extends ConsumerWidget {
  final SyncRule rule;
  const _SyncRuleCard({required this.rule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(syncRuleStatsProvider(rule.id));
    final colors = Theme.of(context).colorScheme;

    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          child: Icon(
            rule.type == SyncRuleType.album
                ? Icons.photo_album_outlined
                : Icons.calendar_month_outlined,
            color: colors.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(_ruleTitle(rule)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rule.downloadFull ? 'Qualità originale' : 'Preview alta risoluzione',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
            statsAsync.when(
              loading: () => const SizedBox(height: 14),
              error: (_, _) => const SizedBox.shrink(),
              data: (stats) => Text(
                stats.fileCount == 0
                    ? 'Nessun file in cache'
                    : '${stats.fileCount} file · ${_formatBytes(stats.sizeBytes)}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
            if (rule.lastSyncedAt != null)
              Text(
                'Ultima sync: ${_formatDate(rule.lastSyncedAt!)}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Rimuovi',
          onPressed: () => _confirmDelete(context, ref),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rimuovi regola'),
        content: Text(
          'Rimuovere "${_ruleTitle(rule)}" e i file in cache associati?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(syncRulesProvider.notifier).deleteRule(rule.id).then((_) {
                ref.invalidate(syncTotalCacheBytesProvider);
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Rimuovi'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Total cache card
// ---------------------------------------------------------------------------

class _TotalCacheCard extends ConsumerWidget {
  const _TotalCacheCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytesAsync = ref.watch(syncTotalCacheBytesProvider);

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.storage_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cache offline', style: Theme.of(context).textTheme.labelSmall),
                  bytesAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => const Text('—'),
                    data: (bytes) => Text(
                      bytes == 0 ? 'Vuota' : _formatBytes(bytes),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyRules extends StatelessWidget {
  const _EmptyRules();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'Nessuna regola configurata',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Aggiungi una regola per accedere alle foto offline.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error view
// ---------------------------------------------------------------------------

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
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message.replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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

// ---------------------------------------------------------------------------
// Add rule bottom sheet
// ---------------------------------------------------------------------------

class _AddRuleSheet extends ConsumerStatefulWidget {
  const _AddRuleSheet();

  @override
  ConsumerState<_AddRuleSheet> createState() => _AddRuleSheetState();
}

class _AddRuleSheetState extends ConsumerState<_AddRuleSheet> {
  SyncRuleType _type = SyncRuleType.album;
  final Set<String> _selectedAlbumIds = {};
  final Map<String, String> _albumNames = {};
  int _daysBack = 30;
  bool _downloadFull = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.88,
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                Text('Nuova regola', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<SyncRuleType>(
              segments: const [
                ButtonSegment(
                  value: SyncRuleType.album,
                  label: Text('Album'),
                  icon: Icon(Icons.photo_album_outlined),
                ),
                ButtonSegment(
                  value: SyncRuleType.timeRange,
                  label: Text('Periodo'),
                  icon: Icon(Icons.calendar_month_outlined),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() {
                _type = v.first;
                _selectedAlbumIds.clear();
                _albumNames.clear();
              }),
            ),
          ),
          const SizedBox(height: 8),
          // Content
          Expanded(
            child: _type == SyncRuleType.album
                ? _AlbumSelector(
                    selected: _selectedAlbumIds,
                    onToggle: (clusterId, name, selected) => setState(() {
                      if (selected) {
                        _selectedAlbumIds.add(clusterId);
                        _albumNames[clusterId] = name;
                      } else {
                        _selectedAlbumIds.remove(clusterId);
                        _albumNames.remove(clusterId);
                      }
                    }),
                  )
                : _TimeRangeSelector(
                    selected: _daysBack,
                    onChanged: (v) => setState(() => _daysBack = v),
                  ),
          ),
          const Divider(height: 1),
          // Quality toggle
          SwitchListTile(
            title: const Text('Scarica originale'),
            subtitle: const Text('File interi via WebDAV. Default: preview 1920px'),
            value: _downloadFull,
            onChanged: (v) => setState(() => _downloadFull = v),
          ),
          const Divider(height: 1),
          // Confirm
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _canConfirm() && !_saving ? _confirm : null,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Aggiungi'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canConfirm() {
    if (_type == SyncRuleType.album) return _selectedAlbumIds.isNotEmpty;
    return true;
  }

  Future<void> _confirm() async {
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      if (_type == SyncRuleType.album) {
        for (final clusterId in _selectedAlbumIds) {
          await ref.read(syncRulesProvider.notifier).saveRule(SyncRule(
                id: 0,
                type: SyncRuleType.album,
                clusterId: clusterId,
                albumName: _albumNames[clusterId],
                downloadFull: _downloadFull,
                createdAt: now,
              ));
        }
      } else {
        await ref.read(syncRulesProvider.notifier).saveRule(SyncRule(
              id: 0,
              type: SyncRuleType.timeRange,
              daysBack: _daysBack,
              downloadFull: _downloadFull,
              createdAt: now,
            ));
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e')),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Album selector (inside the sheet)
// ---------------------------------------------------------------------------

class _AlbumSelector extends ConsumerWidget {
  final Set<String> selected;
  final void Function(String clusterId, String name, bool selected) onToggle;

  const _AlbumSelector({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final existingClusterIds = (ref.watch(syncRulesProvider).valueOrNull ?? [])
        .where((r) => r.type == SyncRuleType.album)
        .map((r) => r.clusterId)
        .whereType<String>()
        .toSet();

    return albumsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Errore nel caricamento degli album.\n${e.toString().replaceAll('Exception: ', '')}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (albums) {
        final available =
            albums.where((a) => !existingClusterIds.contains(a.clusterId)).toList();
        if (available.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Tutti gli album sono già configurati.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: available.length,
          itemBuilder: (context, i) {
            final album = available[i];
            return CheckboxListTile(
              value: selected.contains(album.clusterId),
              title: Text(album.name),
              subtitle: Text('${album.count} foto'),
              onChanged: (v) => onToggle(album.clusterId, album.name, v ?? false),
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Time range selector (inside the sheet)
// ---------------------------------------------------------------------------

class _TimeRangeSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _TimeRangeSelector({required this.selected, required this.onChanged});

  static const _presets = [
    (days: 7, label: 'Ultimi 7 giorni'),
    (days: 30, label: 'Ultimi 30 giorni'),
    (days: 90, label: 'Ultimi 3 mesi'),
    (days: 365, label: 'Ultimo anno'),
  ];

  @override
  Widget build(BuildContext context) {
    return RadioGroup<int>(
      groupValue: selected,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: _presets
            .map(
              (p) => RadioListTile<int>(
                value: p.days,
                title: Text(p.label),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _ruleTitle(SyncRule rule) {
  if (rule.type == SyncRuleType.album) return rule.albumName ?? rule.clusterId ?? 'Album';
  return switch (rule.daysBack) {
    7 => 'Ultimi 7 giorni',
    30 => 'Ultimi 30 giorni',
    90 => 'Ultimi 3 mesi',
    365 => 'Ultimo anno',
    _ => 'Ultimi ${rule.daysBack} giorni',
  };
}

String _formatBytes(int bytes) {
  if (bytes == 0) return '0 B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

String _formatDate(DateTime dt) =>
    '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
