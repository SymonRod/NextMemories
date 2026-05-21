import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/server_config_model.dart';

class AuthLocalDatasource {
  static const _key = 'server_config';

  final FlutterSecureStorage _storage;
  const AuthLocalDatasource(this._storage);

  Future<ServerConfigModel?> getConfig() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    return ServerConfigModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveConfig(ServerConfigModel model) async {
    await _storage.write(key: _key, value: jsonEncode(model.toJson()));
  }

  Future<void> clearConfig() async {
    await _storage.delete(key: _key);
  }
}
