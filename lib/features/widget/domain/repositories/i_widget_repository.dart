import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/widget_album_config.dart';

abstract class IWidgetRepository {
  /// Returns the album currently pinned to the widget, if any.
  Future<Either<Failure, Option<WidgetAlbumConfig>>> getPinnedAlbum();

  /// Pins [config] and immediately refreshes the widget with one of its photos.
  Future<Either<Failure, Unit>> pinAlbum(WidgetAlbumConfig config);

  /// Removes the pinned album and clears the widget.
  Future<Either<Failure, Unit>> unpinAlbum();

  /// Picks a photo from the pinned album cache and pushes it to the widget.
  Future<Either<Failure, Unit>> refreshWidget();
}
