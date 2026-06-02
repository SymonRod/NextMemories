// ignore_for_file: prefer_initializing_formals
import 'dart:io';
import 'dart:math';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../sync/domain/repositories/i_sync_repository.dart';
import '../../domain/entities/widget_album_config.dart';
import '../../domain/repositories/i_widget_repository.dart';
import '../datasources/home_widget_datasource.dart';
import '../datasources/widget_local_datasource.dart';

class WidgetRepositoryImpl implements IWidgetRepository {
  final WidgetLocalDatasource _local;
  final HomeWidgetDatasource _homeWidget;
  final ISyncRepository _sync;
  final Random _random;

  WidgetRepositoryImpl({
    required WidgetLocalDatasource local,
    required HomeWidgetDatasource homeWidget,
    required ISyncRepository sync,
    Random? random,
  })  : _local = local,
        _homeWidget = homeWidget,
        _sync = sync,
        _random = random ?? Random();

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
      final config = await _local.getPinnedAlbum();
      if (config == null) {
        await _clearWidget();
        return const Right(unit);
      }

      final pathsResult = await _sync.getLocalPhotoPathsForRule(config.ruleId);
      final paths = pathsResult.getOrElse((_) => <String>[]);
      // Keep only files still present on disk.
      final existing = paths.where((p) => File(p).existsSync()).toList();
      if (existing.isEmpty) {
        await _clearWidget();
        return const Right(unit);
      }

      final pick = existing[_random.nextInt(existing.length)];
      await _homeWidget.setData(
        imagePath: pick,
        albumName: config.albumName,
        clusterId: config.clusterId,
      );
      await _homeWidget.update();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<void> _clearWidget() async {
    await _homeWidget.clearData();
    await _homeWidget.update();
  }
}
