import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsync = ref.watch(userInfoProvider);
    final config = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: userInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString(), onRetry: () => ref.invalidate(userInfoProvider)),
        data: (info) => _ProfileBody(
          info: info,
          serverUrl: config?.serverUrl ?? '',
          avatarUrl: config != null
              ? '${config.serverUrl}/index.php/avatar/${config.username}/256'
              : null,
          authHeaders: config != null
              ? {
                  'Authorization': 'Basic ${base64Encode(utf8.encode('${config.username}:${config.appPassword}'))}',
                }
              : null,
          onLogout: () => ref.read(authProvider.notifier).logout(),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final dynamic info;
  final String serverUrl;
  final String? avatarUrl;
  final Map<String, String>? authHeaders;
  final VoidCallback onLogout;

  const _ProfileBody({
    required this.info,
    required this.serverUrl,
    required this.avatarUrl,
    required this.authHeaders,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        _AvatarSection(avatarUrl: avatarUrl, authHeaders: authHeaders, displayName: info.displayName),
        const SizedBox(height: 16),
        Text(
          info.displayName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          '@${info.id}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        if (info.email != null) ...[
          const SizedBox(height: 4),
          Text(
            info.email!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        const SizedBox(height: 32),
        _InfoCard(
          icon: Icons.dns_outlined,
          label: 'Server',
          value: serverUrl,
        ),
        const SizedBox(height: 12),
        _QuotaCard(quota: info.quota),
        const SizedBox(height: 40),
        FilledButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          label: const Text('Disconnetti'),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
        ),
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String? avatarUrl;
  final Map<String, String>? authHeaders;
  final String displayName;

  const _AvatarSection({
    required this.avatarUrl,
    required this.authHeaders,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 52,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: avatarUrl != null
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  httpHeaders: authHeaders,
                  width: 104,
                  height: 104,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _InitialAvatar(displayName: displayName),
                ),
              )
            : _InitialAvatar(displayName: displayName),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String displayName;
  const _InitialAvatar({required this.displayName});

  @override
  Widget build(BuildContext context) {
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    return Text(
      initial,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelSmall),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuotaCard extends StatelessWidget {
  final dynamic quota;
  const _QuotaCard({required this.quota});

  String _formatBytes(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final isUnlimited = quota.unlimited as bool;
    final used = quota.used as int;
    final total = quota.total as int;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text('Storage', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 12),
            if (!isUnlimited) ...[
              LinearProgressIndicator(
                value: quota.progressValue as double,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatBytes(used)} / ${_formatBytes(total)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ] else ...[
              Text(
                '${_formatBytes(used)} utilizzati',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Spazio illimitato',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Riprova')),
          ],
        ),
      ),
    );
  }
}
