import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/server_config.dart';

part 'server_config_model.freezed.dart';
part 'server_config_model.g.dart';

@freezed
class ServerConfigModel with _$ServerConfigModel {
  const factory ServerConfigModel({
    required String serverUrl,
    required String username,
    required String appPassword,
  }) = _ServerConfigModel;

  factory ServerConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigModelFromJson(json);
}

extension ServerConfigModelX on ServerConfigModel {
  ServerConfig toEntity() => ServerConfig(
        serverUrl: serverUrl,
        username: username,
        appPassword: appPassword,
      );
}

extension ServerConfigX on ServerConfig {
  ServerConfigModel toModel() => ServerConfigModel(
        serverUrl: serverUrl,
        username: username,
        appPassword: appPassword,
      );
}
