import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/timeline/domain/entities/photo.dart';
import '../api/memories_api.dart';

class ShareService {
  /// Downloads [photos] to a temporary directory and returns the ready [XFile]s.
  /// Call [Share.shareXFiles] separately after dismissing any loading UI.
  ///
  /// [useOriginal] → true = full-res via stream endpoint (or local file if cached);
  ///                 false = preview thumbnail (1024×1024).
  static Future<List<XFile>> prepareFiles({
    required List<Photo> photos,
    required bool useOriginal,
    required String serverUrl,
    required String authHeader,
  }) async {
    final dio = Dio(BaseOptions(
      baseUrl: serverUrl,
      headers: {'Authorization': authHeader},
      receiveTimeout: const Duration(seconds: 60),
    ));

    final tempDir = await getTemporaryDirectory();
    final shareDir = Directory('${tempDir.path}/nm_share');
    await shareDir.create(recursive: true);

    final xFiles = <XFile>[];

    for (final photo in photos) {
      try {
        if (useOriginal && photo.localPath != null) {
          xFiles.add(XFile(photo.localPath!, name: photo.basename, mimeType: photo.mimetype));
          continue;
        }

        final path = useOriginal
            ? MemoriesApi.stream(photo.fileId)
            : MemoriesApi.photoPreview(photo.fileId, etag: photo.etag ?? '', x: 1024, y: 1024);

        final ext = useOriginal ? _extFromBasename(photo.basename) : 'jpg';
        final dest = '${shareDir.path}/${photo.fileId}.$ext';

        await dio.download(path, dest);
        xFiles.add(XFile(dest, name: photo.basename, mimeType: photo.mimetype));
      } catch (_) {
        // Skip failed photo, continue with the rest.
      }
    }

    if (xFiles.isEmpty) throw Exception('Nessun file da condividere');

    return xFiles;
  }

  static String _extFromBasename(String basename) {
    final dot = basename.lastIndexOf('.');
    return dot >= 0 ? basename.substring(dot + 1).toLowerCase() : 'jpg';
  }
}
