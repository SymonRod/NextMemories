class MemoriesApi {
  MemoriesApi._();

  static const String basePath = '/apps/memories/api';
  static const String webdavBasePath = '/remote.php/dav/files';
  static const String _ocsBasePath = '/ocs/v2.php/cloud';

  static String ocsUser(String username) => '$_ocsBasePath/users/$username';

  static String days() => '$basePath/days';
  static String dayPhotos(int dayId) => '$basePath/days/$dayId';

  static String albums() => '$basePath/clusters/albums';
  static String albumDays(String clusterId) => '$basePath/days?albums=${Uri.encodeComponent(clusterId)}';

  static String photoInfo(int fileId) => '$basePath/image/info/$fileId';
  static String photoPreview(int fileId, {required String etag, int x = 512, int y = 512}) =>
      '$basePath/image/preview/$fileId?c=$etag&x=$x&y=$y&a=1';

  static String webdavUser(String username) => '$webdavBasePath/$username/';
}
