import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../auth/domain/entities/server_config.dart';

typedef DownloadResult = ({String localPath, int sizeBytes});

class SyncDownloadDatasource {
  final ServerConfig _config;
  late final Dio _dio = _buildDio();
  late final webdav.Client _webdav = _buildWebdavClient();

  SyncDownloadDatasource(this._config);

  Dio _buildDio() {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  webdav.Client _buildWebdavClient() => webdav.newClient(
        _config.serverUrl,
        user: _config.username,
        password: _config.appPassword,
      );

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

  Future<DownloadResult> downloadOriginal({
    required int fileId,
    required String basename,
    required String mimetype,
  }) async {
    final dir = await _syncDir();
    final ext = _ext(mimetype, basename);
    final partPath = p.join(dir.path, '$fileId.$ext.part');
    final finalPath = p.join(dir.path, '$fileId.$ext');

    final infoResponse = await _dio.get<Map<String, dynamic>>(
      MemoriesApi.photoInfo(fileId),
    );
    final davFilename = infoResponse.data!['filename'] as String;

    // read2File accetta l'URL completo perché il client interno skippa
    // il join con la base URI quando il path comincia con http(s)://.
    final fullUrl =
        '${_config.serverUrl}${MemoriesApi.webdavBasePath}/${_config.username}$davFilename';
    await _webdav.read2File(fullUrl, partPath);

    final sizeBytes = await File(partPath).length();
    await File(partPath).rename(finalPath);

    return (localPath: finalPath, sizeBytes: sizeBytes);
  }
}
