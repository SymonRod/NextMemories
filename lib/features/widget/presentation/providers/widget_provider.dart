import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sync/presentation/providers/sync_rules_provider.dart';
import '../../data/datasources/home_widget_datasource.dart';
import '../../data/datasources/widget_local_datasource.dart';
import '../../data/repositories/widget_repository_impl.dart';
import '../../domain/entities/widget_album_config.dart';
import '../../domain/repositories/i_widget_repository.dart';
import '../../domain/usecases/get_pinned_album_use_case.dart';
import '../../domain/usecases/pin_album_to_widget_use_case.dart';
import '../../domain/usecases/refresh_album_widget_use_case.dart';
import '../../domain/usecases/unpin_album_from_widget_use_case.dart';

part 'widget_provider.g.dart';

@Riverpod(keepAlive: true)
IWidgetRepository widgetRepository(Ref ref) {
  final sync = ref.watch(syncRepositoryProvider);
  return WidgetRepositoryImpl(
    local: WidgetLocalDatasource(),
    homeWidget: HomeWidgetDatasource(),
    sync: sync,
  );
}

@riverpod
class PinnedAlbumWidget extends _$PinnedAlbumWidget {
  late IWidgetRepository _repo;

  @override
  Future<WidgetAlbumConfig?> build() async {
    _repo = ref.watch(widgetRepositoryProvider);
    final result = await GetPinnedAlbumUseCase(_repo)();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (option) => option.toNullable(),
    );
  }

  Future<void> pin(WidgetAlbumConfig config) async {
    final result = await PinAlbumToWidgetUseCase(_repo)(config);
    result.fold((failure) => throw Exception(failure.message), (_) {});
    ref.invalidateSelf();
  }

  Future<void> unpin() async {
    final result = await UnpinAlbumFromWidgetUseCase(_repo)();
    result.fold((failure) => throw Exception(failure.message), (_) {});
    ref.invalidateSelf();
  }

  /// Re-picks a photo for the currently pinned album. No-op if nothing pinned.
  Future<void> refresh() async {
    await RefreshAlbumWidgetUseCase(_repo)();
  }
}
