import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/memories_api.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../timeline/presentation/providers/timeline_provider.dart';
import '../providers/favorite_provider.dart';

class ViewerScreen extends ConsumerStatefulWidget {
  final int dayId;
  final int initialIndex;

  const ViewerScreen({
    super.key,
    required this.dayId,
    required this.initialIndex,
  });

  @override
  ConsumerState<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends ConsumerState<ViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _showUi = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleUi() => setState(() => _showUi = !_showUi);

  @override
  Widget build(BuildContext context) {
    final photosAsync = ref.watch(dayPhotosProvider(widget.dayId));
    final config = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      backgroundColor: Colors.black,
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(e.toString(), style: const TextStyle(color: Colors.white)),
        ),
        data: (photos) {
          if (config == null || photos.isEmpty) return const SizedBox.shrink();

          final credentials = base64Encode(
            utf8.encode('${config.username}:${config.appPassword}'),
          );
          final photo = photos[_currentIndex];

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: photos.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final p = photos[index];
                  final url =
                      '${config.serverUrl}${MemoriesApi.photoPreview(p.fileId, etag: p.etag ?? '', x: 1920, y: 1920)}';
                  return GestureDetector(
                    onTap: _toggleUi,
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 5,
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: url,
                          httpHeaders: {'Authorization': 'Basic $credentials'},
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: Colors.white54),
                          ),
                          errorWidget: (context, url, err) => const Icon(
                            Icons.broken_image_rounded,
                            color: Colors.white54,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedOpacity(
                opacity: _showUi ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                      title: Text(
                        photo.basename,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      actions: [
                        _FavoriteButton(fileId: photo.fileId),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      color: Colors.black54,
                      child: Text(
                        '${_currentIndex + 1} / ${photos.length}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  final int fileId;
  const _FavoriteButton({required this.fileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoriteProvider(fileId));

    return favAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
        ),
      ),
      error: (e, _) => const Icon(Icons.star_border_rounded, color: Colors.white54),
      data: (isFavorite) => IconButton(
        icon: Icon(
          isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
          color: isFavorite ? Colors.amber : Colors.white,
        ),
        onPressed: () => ref.read(favoriteProvider(fileId).notifier).toggle(fileId),
      ),
    );
  }
}
