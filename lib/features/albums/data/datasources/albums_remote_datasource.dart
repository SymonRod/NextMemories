import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../../../features/timeline/data/models/photo_day_model.dart';
import '../../../../features/timeline/data/models/photo_model.dart';
import '../models/album_model.dart';

final _hrefRegex = RegExp(r'<d:href>([^<]+)</d:href>');
final _fileIdRegex = RegExp(r'<oc:fileid>(\d+)</oc:fileid>');
final _responseBlockRegex = RegExp(r'<d:response>(.*?)</d:response>', dotAll: true);

class AlbumsRemoteDatasource {
  final ServerConfig _config;
  late final Dio _dio = _buildDio();

  AlbumsRemoteDatasource(this._config);

  Dio _buildDio() {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  Future<List<AlbumModel>> getAlbums() async {
    try {
      final response = await _dio.get(MemoriesApi.albums());
      debugPrint('[Albums] GET /clusters/albums status: ${response.statusCode}');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => AlbumModel.fromJson(e as Map<String, dynamic>))
          .where((a) => !a.name.startsWith('.link-'))
          .toList();
    } catch (e) {
      debugPrint('[Albums] GET /clusters/albums ERROR: $e');
      rethrow;
    }
  }

  /// Resolves [fileIds] to their server-relative paths via WebDAV SEARCH.
  Future<Map<int, String>> resolveFileIds(List<int> fileIds) async {
    final eqClauses = fileIds.map((id) => '''
        <d:eq><d:prop><oc:fileid/></d:prop><d:literal>$id</d:literal></d:eq>''').join('\n');
    final xml = '''<?xml version="1.0" encoding="UTF-8"?>
<d:searchrequest xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns" xmlns:ns="https://github.com/icewind1991/SearchDAV/ns" xmlns:ocs="http://open-collaboration-services.org/ns">
  <d:basicsearch>
    <d:select><d:prop><oc:fileid /></d:prop></d:select>
    <d:from><d:scope><d:href>/files/${_config.username}</d:href><d:depth>0</d:depth></d:scope></d:from>
    <d:where><d:or>$eqClauses</d:or></d:where>
  </d:basicsearch>
</d:searchrequest>''';

    final response = await _dio.request<String>(
      MemoriesApi.webdavSearchPath,
      options: Options(
        method: 'SEARCH',
        contentType: 'application/xml',
        responseType: ResponseType.plain,
      ),
      data: xml,
    );

    final body = response.data ?? '';
    final pathPrefix = '/remote.php/dav/files/${_config.username}';
    final result = <int, String>{};

    for (final block in _responseBlockRegex.allMatches(body)) {
      final content = block.group(1)!;
      final href = _hrefRegex.firstMatch(content)?.group(1);
      final fileIdStr = _fileIdRegex.firstMatch(content)?.group(1);
      if (href == null || fileIdStr == null) continue;
      final fileId = int.tryParse(fileIdStr);
      if (fileId == null) continue;
      final path = href.startsWith(pathPrefix) ? href.substring(pathPrefix.length) : href;
      result[fileId] = path;
    }
    debugPrint('[Albums] resolveFileIds: ${result.length}/${fileIds.length} resolved');
    return result;
  }

  /// Adds photos to a Nextcloud Photos album via WebDAV COPY.
  /// [albumName] is the album's display name as it appears in the Photos app.
  /// Steps: SEARCH resolves fileIds → server paths, then COPY each file into
  /// /remote.php/dav/photos/{user}/albums/{albumName}/.
  Future<void> addPhotosToAlbum(String albumName, List<int> fileIds) async {
    final paths = await resolveFileIds(fileIds);
    if (paths.isEmpty) {
      debugPrint('[Albums] addPhotosToAlbum: no paths resolved, aborting');
      return;
    }

    final encodedAlbum = Uri.encodeComponent(albumName);

    for (final entry in paths.entries) {
      // entry.value is already URI-encoded (from the DAV href), so use it
      // directly for the source path. Decode before re-encoding in Destination
      // to avoid double-percent-encoding filenames with spaces or special chars.
      final sourcePath =
          '/remote.php/dav/files/${_config.username}${entry.value}';
      final rawFilename = Uri.decodeComponent(entry.value.split('/').last);
      final encodedFilename = Uri.encodeComponent(rawFilename);
      final destination =
          '${_config.serverUrl}/remote.php/dav/photos/${_config.username}/albums/$encodedAlbum/$encodedFilename';

      try {
        await _dio.request<void>(
          sourcePath,
          options: Options(
            method: 'COPY',
            headers: {'Destination': destination},
          ),
        );
        debugPrint('[Albums] COPY ${entry.value} → albums/$albumName/$rawFilename');
      } on DioException catch (e) {
        if (e.response?.statusCode == 409) {
          // 409 Conflict = file already exists in the album, nothing to do.
          debugPrint('[Albums] COPY skipped (already in album): $rawFilename');
          continue;
        }
        debugPrint('[Albums] COPY ERROR for fileId=${entry.key}: $e');
        rethrow;
      }
    }
    debugPrint('[Albums] addPhotosToAlbum "$albumName": ${paths.length} photos added');
  }

  /// Removes photos from a Nextcloud Photos album via WebDAV DELETE.
  /// [fileIdToBasename] maps each fileId to its basename so we can construct
  /// the album entry path: /photos/{user}/albums/{albumName}/{fileId}-{basename}
  Future<void> removePhotosFromAlbum(
    String albumName,
    Map<int, String> fileIdToBasename,
  ) async {
    final encodedAlbum = Uri.encodeComponent(albumName);

    for (final entry in fileIdToBasename.entries) {
      final rawFilename = '${entry.key}-${entry.value}';
      final encodedFilename = Uri.encodeComponent(rawFilename);
      final path =
          '/remote.php/dav/photos/${_config.username}/albums/$encodedAlbum/$encodedFilename';
      try {
        await _dio.request<void>(path, options: Options(method: 'DELETE'));
        debugPrint('[Albums] DELETE album entry: $rawFilename');
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          debugPrint('[Albums] DELETE skipped (not in album): $rawFilename');
          continue;
        }
        debugPrint('[Albums] DELETE ERROR for fileId=${entry.key}: $e');
        rethrow;
      }
    }
    debugPrint(
        '[Albums] removePhotosFromAlbum "$albumName": ${fileIdToBasename.length} removed');
  }

  Future<List<PhotoModel>> getAlbumPhotos(String clusterId) async {
    try {
      // Step 1: get day buckets to know all dayIds in this album.
      final daysResp = await _dio.get(MemoriesApi.albumDays(clusterId));
      debugPrint('[Albums] GET albumDays status: ${daysResp.statusCode}');
      final days = (daysResp.data as List<dynamic>)
          .map((e) => PhotoDayModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (days.isEmpty) return [];

      // Step 2: batch-fetch all photos via POST, same as the timeline does.
      final dayIds = days.map((d) => d.dayId).toList();
      final photosResp = await _dio.post(
        MemoriesApi.albumDaysPhotos(clusterId),
        data: {'dayIds': dayIds},
        options: Options(contentType: 'application/json'),
      );
      debugPrint('[Albums] POST albumDaysPhotos status: ${photosResp.statusCode}');
      final photos = (photosResp.data as List<dynamic>)
          .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList();

      debugPrint('[Albums] Total album photos: ${photos.length}');
      return photos;
    } catch (e) {
      debugPrint('[Albums] getAlbumPhotos ERROR: $e');
      rethrow;
    }
  }
}
