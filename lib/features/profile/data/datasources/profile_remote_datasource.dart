import 'package:dio/dio.dart';

import '../../../../core/api/auth_interceptor.dart';
import '../../../../core/api/memories_api.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../models/user_info_model.dart';

class ProfileRemoteDatasource {
  final ServerConfig _config;
  const ProfileRemoteDatasource(this._config);

  Dio get _dio {
    final dio = Dio(BaseOptions(baseUrl: _config.serverUrl));
    dio.interceptors.add(AuthInterceptor(
      username: _config.username,
      appPassword: _config.appPassword,
    ));
    return dio;
  }

  Future<UserInfoModel> getUserInfo() async {
    final response = await _dio.get(
      MemoriesApi.ocsUser(_config.username),
      queryParameters: {'format': 'json'},
    );
    final data = response.data['ocs']['data'] as Map<String, dynamic>;
    return UserInfoModel.fromJson(data);
  }
}
