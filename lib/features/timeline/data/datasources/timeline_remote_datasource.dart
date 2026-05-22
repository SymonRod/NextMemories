import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../models/photo_day_model.dart';
import '../models/photo_model.dart';

class TimelineRemoteDatasource {
  final ServerConfig _config;
  late final Dio _dio = _buildDio();

  TimelineRemoteDatasource(this._config);

  Dio _buildDio() {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  Future<List<PhotoDayModel>> getDays() async {
    try {
      final response = await _dio.get(MemoriesApi.days());
      debugPrint('[Timeline] GET /days status: ${response.statusCode}, items: ${(response.data as List).length}');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => PhotoDayModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[Timeline] GET /days ERROR: $e');
      rethrow;
    }
  }

  Future<List<PhotoModel>> getDayPhotos(int dayId) async {
    try {
      final response = await _dio.post(
        MemoriesApi.days(),
        data: {'dayIds': [dayId]},
        options: Options(contentType: 'application/json'),
      );
      debugPrint('[Timeline] POST /days/$dayId status: ${response.statusCode}, photos: ${(response.data as List).length}');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[Timeline] POST /days/$dayId ERROR: $e');
      rethrow;
    }
  }
}
