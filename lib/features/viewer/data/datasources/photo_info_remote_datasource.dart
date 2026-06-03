import 'package:dio/dio.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../models/photo_info_model.dart';

class PhotoInfoRemoteDatasource {
  final ServerConfig _config;
  late final Dio _dio = _buildDio();

  PhotoInfoRemoteDatasource(this._config);

  Dio _buildDio() {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  Future<PhotoInfoModel> fetch(int fileId) async {
    final response = await _dio.get(MemoriesApi.photoInfo(fileId));
    return PhotoInfoModel.fromJson(response.data as Map<String, dynamic>);
  }
}
