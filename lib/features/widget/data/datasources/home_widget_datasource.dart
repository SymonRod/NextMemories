import 'package:home_widget/home_widget.dart';

/// Thin wrapper over the `home_widget` plugin. Writes the data consumed by the
/// native [AlbumWidgetProvider] and triggers a redraw.
///
/// The image is passed as a file path; downsampling to widget size happens on
/// the native side to avoid `TransactionTooLargeException`.
class HomeWidgetDatasource {
  // Must match the AppWidgetProvider declared in the Android manifest.
  static const _androidWidgetName = 'AlbumWidgetProvider';
  static const _qualifiedAndroidName =
      'com.simonerodino.next_memories.widgets.AlbumWidgetProvider';

  // Keys read by the native provider.
  static const keyImagePath = 'album_widget_image_path';
  static const keyAlbumName = 'album_widget_album_name';
  static const keyClusterId = 'album_widget_cluster_id';

  Future<void> setData({
    required String imagePath,
    required String albumName,
    required String clusterId,
  }) async {
    await HomeWidget.saveWidgetData<String>(keyImagePath, imagePath);
    await HomeWidget.saveWidgetData<String>(keyAlbumName, albumName);
    await HomeWidget.saveWidgetData<String>(keyClusterId, clusterId);
  }

  Future<void> clearData() async {
    await HomeWidget.saveWidgetData<String?>(keyImagePath, null);
    await HomeWidget.saveWidgetData<String?>(keyAlbumName, null);
    await HomeWidget.saveWidgetData<String?>(keyClusterId, null);
  }

  Future<void> update() async {
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      qualifiedAndroidName: _qualifiedAndroidName,
    );
  }
}
