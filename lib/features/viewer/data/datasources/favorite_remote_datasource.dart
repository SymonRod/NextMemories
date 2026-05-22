import 'package:dio/dio.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../../features/auth/domain/entities/server_config.dart';

class FavoriteRemoteDatasource {
  final ServerConfig _config;
  late final Dio _dio = _buildDio();

  FavoriteRemoteDatasource(this._config);

  Dio _buildDio() {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  Future<String> getFilename(int fileId) async {
    final response = await _dio.get(MemoriesApi.photoInfo(fileId));
    final data = response.data as Map<String, dynamic>;
    return data['filename'] as String? ?? '';
  }

  Future<({String filename, bool isFavorite})> getPhotoInfo(int fileId) async {
    final filename = await getFilename(fileId);

    final davPath =
        '${MemoriesApi.webdavBasePath}/${_config.username}$filename';
    final propfindResponse = await _dio.request(
      davPath,
      data: '''<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns">
  <d:prop><oc:favorite/></d:prop>
</d:propfind>''',
      options: Options(
        method: 'PROPFIND',
        contentType: 'application/xml',
        headers: {'Depth': '0'},
        responseType: ResponseType.plain,
      ),
    );
    final xml = propfindResponse.data as String;
    final isFavorite = xml.contains('<oc:favorite>1</oc:favorite>');

    return (filename: filename, isFavorite: isFavorite);
  }

  Future<void> setFavorite(String filename, {required bool favorite}) async {
    final davPath =
        '${MemoriesApi.webdavBasePath}/${_config.username}$filename';
    final value = favorite ? '1' : '0';
    final xml = '''<?xml version="1.0"?>
<d:propertyupdate xmlns:d="DAV:"
  xmlns:oc="http://owncloud.org/ns"
  xmlns:nc="http://nextcloud.org/ns">
<d:set>
  <d:prop>
    <oc:favorite>$value</oc:favorite>
  </d:prop>
</d:set>
</d:propertyupdate>''';

    await _dio.request(
      davPath,
      data: xml,
      options: Options(
        method: 'PROPPATCH',
        contentType: 'application/xml',
      ),
    );
  }
}
