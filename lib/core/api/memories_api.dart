class MemoriesApi {
  MemoriesApi._();

  static const String basePath = '/index.php/apps/memories/api/v1';
  static const String webdavBasePath = '/remote.php/dav/files';
  static const String _ocsBasePath = '/ocs/v2.php/cloud';

  static String ocsUser(String username) => '$_ocsBasePath/users/$username';

  static String days() => '$basePath/days';
  static String dayPhotos(int dayId) => '$basePath/days/$dayId';

  static String albums() => '$basePath/albums';
  static String albumPhotos(String albumId) => '$basePath/albums/$albumId';

  static String photoInfo(int fileId) => '$basePath/photo/$fileId/info';
  static String photoPreview(int fileId) => '$basePath/photo/$fileId/preview';

  static String webdavUser(String username) => '$webdavBasePath/$username/';
}
