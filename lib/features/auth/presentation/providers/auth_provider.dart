import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/usecases/get_credentials_use_case.dart';
import '../../domain/usecases/save_credentials_use_case.dart';
import '../../domain/usecases/validate_connection_use_case.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  AuthRepositoryImpl get _repo => AuthRepositoryImpl.instance;

  @override
  Future<ServerConfig?> build() async {
    final result = await GetCredentialsUseCase(_repo)();
    return result.fold((_) => null, (config) => config);
  }

  /// Returns the error message on failure, null on success.
  Future<String?> login({
    required String serverUrl,
    required String username,
    required String appPassword,
  }) async {
    final cleanUrl = serverUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final config = ServerConfig(
      serverUrl: cleanUrl,
      username: username.trim(),
      appPassword: appPassword,
    );

    final validation = await ValidateConnectionUseCase(_repo)(config);
    if (validation.isLeft()) {
      return validation.fold((f) => f.message, (_) => null);
    }

    await SaveCredentialsUseCase(_repo)(config);
    state = AsyncData(config);
    return null;
  }

  Future<void> logout() async {
    await _repo.clearCredentials();
    state = const AsyncData(null);
  }
}
