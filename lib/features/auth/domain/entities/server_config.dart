import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    required String serverUrl,
    required String username,
    required String appPassword,
  }) = _ServerConfig;
}
