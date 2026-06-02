import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/photo_metadata_cache.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_info.dart';
import '../../domain/usecases/get_user_info_use_case.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'profile_provider.g.dart';

final _profileCache = PhotoMetadataCache();

@riverpod
Stream<UserInfo> userInfo(Ref ref) async* {
  final config = ref.watch(authProvider).valueOrNull;

  // 1. Stale: mostra subito le info utente in cache, se presenti.
  final cached = await _profileCache.getUserInfo();
  if (cached != null) yield cached;

  if (config == null) {
    if (cached != null) return;
    throw Exception('Not authenticated');
  }

  // 2. Revalidate: aggiorna dal server e ri-emetti solo se cambia qualcosa.
  final repo = ProfileRepositoryImpl.fromConfig(config);
  final result = await GetUserInfoUseCase(repo)();
  yield* result.fold(
    (failure) async* {
      if (cached == null) throw Exception(failure.message);
    },
    (fresh) async* {
      await _profileCache.saveUserInfo(fresh);
      if (fresh != cached) yield fresh;
    },
  );
}
