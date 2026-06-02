import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_album_config.freezed.dart';

/// Album pinned to the homescreen "digital frame" widget.
@freezed
class WidgetAlbumConfig with _$WidgetAlbumConfig {
  const factory WidgetAlbumConfig({
    required int ruleId,
    required String clusterId,
    required String albumName,
  }) = _WidgetAlbumConfig;
}
