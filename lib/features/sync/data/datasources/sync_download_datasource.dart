import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../auth/domain/entities/server_config.dart';

typedef DownloadResult = ({String localPath, int sizeBytes});

class SyncDownloadDatasource {
  final ServerConfig _config;
  late final Dio _dio = _buildDio();

  SyncDownloadDatasource(this._config);

  Dio _buildDio() {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  Future<Directory> _syncDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'sync'));
    await dir.create(recursive: true);
    return dir;
  }

  String _ext(String mimetype, String basename) {
    const mimeToExt = {
      'image/jpeg': 'jpg',
      'image/jpg': 'jpg',
      'image/png': 'png',
      'image/heic': 'heic',
      'image/heif': 'heif',
      'image/webp': 'webp',
      'image/gif': 'gif',
      'image/tiff': 'tiff',
      'video/mp4': 'mp4',
      'video/quicktime': 'mov',
      'video/x-msvideo': 'avi',
      'video/webm': 'webm',
    };
    final fromMime = mimeToExt[mimetype.toLowerCase()];
    if (fromMime != null) return fromMime;
    final ext = p.extension(basename);
    return ext.isNotEmpty ? ext.substring(1) : 'bin';
  }

  Future<void> cleanupPartFiles() async {
    final dir = await _syncDir();
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.part')) {
        await entity.delete();
      }
    }
  }

  Future<DownloadResult> downloadPreview({
    required int fileId,
    required String etag,
    required String basename,
    required String mimetype,
  }) async {
    final dir = await _syncDir();
    final ext = _ext(mimetype, basename);
    final partPath = p.join(dir.path, '$fileId.$ext.part');
    final finalPath = p.join(dir.path, '$fileId.$ext');

    await _dio.download(
      MemoriesApi.photoPreview(fileId, etag: etag, x: 1920, y: 1920),
      partPath,
    );
    final sizeBytes = await File(partPath).length();
    await File(partPath).rename(finalPath);

    return (localPath: finalPath, sizeBytes: sizeBytes);
  }

  // S7 — single request via /api/stream instead of GET /image/info + WebDAV.
  Future<DownloadResult> downloadOriginal({
    required int fileId,
    required String basename,
    required String mimetype,
  }) async {
    final dir = await _syncDir();
    final ext = _ext(mimetype, basename);
    final partPath = p.join(dir.path, '$fileId.$ext.part');
    final finalPath = p.join(dir.path, '$fileId.$ext');

    await _dio.download(MemoriesApi.stream(fileId), partPath);

    final sizeBytes = await File(partPath).length();
    await File(partPath).rename(finalPath);

    return (localPath: finalPath, sizeBytes: sizeBytes);
  }
}
