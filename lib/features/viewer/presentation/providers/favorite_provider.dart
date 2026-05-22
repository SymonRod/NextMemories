import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/favorite_remote_datasource.dart';

part 'favorite_provider.g.dart';

@riverpod
class Favorite extends _$Favorite {
  String? _filename;
  FavoriteRemoteDatasource? _ds;

  @override
  Future<bool> build(int fileId) async {
    final config = ref.watch(authProvider).valueOrNull;
    if (config == null) return false;
    ref.keepAlive();
    _ds = FavoriteRemoteDatasource(config);
    final info = await _ds!.getPhotoInfo(fileId);
    _filename = info.filename;
    return info.isFavorite;
  }

  Future<void> toggle(int fileId) async {
    final current = state.valueOrNull ?? false;
    final config = ref.read(authProvider).valueOrNull;
    if (config == null) return;
    final ds = _ds ?? FavoriteRemoteDatasource(config);

    state = AsyncData(!current);
    try {
      final filename = _filename ?? await ds.getFilename(fileId);
      await ds.setFavorite(filename, favorite: !current);
    } catch (e) {
      state = AsyncData(current);
      rethrow;
    }
  }
}
