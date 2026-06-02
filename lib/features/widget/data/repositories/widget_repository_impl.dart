// ignore_for_file: prefer_initializing_formals
import 'dart:math';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../sync/domain/repositories/i_sync_repository.dart';
import '../../domain/entities/widget_album_config.dart';
import '../../domain/repositories/i_widget_repository.dart';
import '../datasources/home_widget_datasource.dart';
import '../datasources/widget_local_datasource.dart';
import '../widget_refresh_runner.dart';

class WidgetRepositoryImpl implements IWidgetRepository {
  final WidgetLocalDatasource _local;
  final HomeWidgetDatasource _homeWidget;
  final ISyncRepository _sync;
  late final WidgetRefreshRunner _runner;

  WidgetRepositoryImpl({
    required WidgetLocalDatasource local,
    required HomeWidgetDatasource homeWidget,
    required ISyncRepository sync,
    Random? random,
  })  : _local = local,
        _homeWidget = homeWidget,
        _sync = sync {
    _runner = WidgetRefreshRunner(
      local: _local,
      homeWidget: _homeWidget,
      getPaths: (ruleId) async =>
          (await _sync.getLocalPhotoPathsForRule(ruleId)).getOrElse((_) => <String>[]),
      random: random,
    );
  }

  @override
  Future<Either<Failure, Option<WidgetAlbumConfig>>> getPinnedAlbum() async {
    try {
      final config = await _local.getPinnedAlbum();
      return Right(Option.fromNullable(config));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> pinAlbum(WidgetAlbumConfig config) async {
    try {
      await _local.setPinnedAlbum(config);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
    return refreshWidget();
  }

  @override
  Future<Either<Failure, Unit>> unpinAlbum() async {
    try {
      await _local.clearPinnedAlbum();
      await _homeWidget.clearData();
      await _homeWidget.update();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshWidget() async {
    try {
      await _runner.refreshAll();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
