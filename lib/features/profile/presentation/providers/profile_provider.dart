import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_info.dart';
import '../../domain/usecases/get_user_info_use_case.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserInfo> userInfo(Ref ref) async {
  final config = ref.watch(authProvider).valueOrNull;
  if (config == null) throw Exception('Not authenticated');
  final repo = ProfileRepositoryImpl.fromConfig(config);
  final result = await GetUserInfoUseCase(repo)();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (info) => info,
  );
}
