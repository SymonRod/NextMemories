import 'dart:convert';

import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String username;
  final String appPassword;

  AuthInterceptor({required this.username, required this.appPassword});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final credentials = base64Encode(utf8.encode('$username:$appPassword'));
    options.headers['Authorization'] = 'Basic $credentials';
    options.headers['OCS-APIREQUEST'] = 'true';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
