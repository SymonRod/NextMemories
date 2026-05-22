import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../../../features/timeline/data/models/photo_day_model.dart';
import '../../../../features/timeline/data/models/photo_model.dart';
import '../models/album_model.dart';

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

  Future<List<PhotoModel>> getAlbumPhotos(String clusterId) async {
    try {
      final response = await _dio.get(MemoriesApi.albumDays(clusterId));
      debugPrint('[Albums] GET albumDays status: ${response.statusCode}');
      final days = (response.data as List<dynamic>)
          .map((e) => PhotoDayModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final photos = days
          .expand((day) => day.detail ?? <PhotoModel>[])
          .toList();
      debugPrint('[Albums] Total album photos: ${photos.length}');
      return photos;
    } catch (e) {
      debugPrint('[Albums] GET albumDays ERROR: $e');
      rethrow;
    }
  }
}
