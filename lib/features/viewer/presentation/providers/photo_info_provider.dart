import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/photo_info_remote_datasource.dart';
import '../../data/models/photo_info_model.dart';

part 'photo_info_provider.g.dart';

@riverpod
class PhotoInfo extends _$PhotoInfo {
  late final PhotoInfoRemoteDatasource _ds;

  @override
  Future<PhotoInfoModel> build(int fileId) async {
    final config = ref.watch(authProvider).valueOrNull;
    if (config == null) throw StateError('Not authenticated');
    ref.keepAlive();
    _ds = PhotoInfoRemoteDatasource(config);
    return _ds.fetch(fileId);
  }
}
