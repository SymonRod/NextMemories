import 'package:hive_flutter/hive_flutter.dart';

import '../../features/albums/domain/entities/album.dart';
import '../../features/profile/domain/entities/user_info.dart';
import '../../features/timeline/domain/entities/photo.dart';
import '../../features/timeline/domain/entities/photo_day.dart';

class PhotoMetadataCache {
  static const _boxName = 'photo_metadata_cache';
  static const _daysKey = 'days';

  Box<dynamic>? _box;

  Future<Box<dynamic>> _open() async {
    _box ??= await Hive.openBox<dynamic>(_boxName);
    return _box!;
  }

  // --- Days ---

  Future<void> saveDays(List<PhotoDay> days) async {
    final box = await _open();
    await box.put(_daysKey, days.map(_dayToMap).toList());
  }

  Future<List<PhotoDay>?> getDays() async {
    final box = await _open();
    final raw = box.get(_daysKey);
    if (raw == null) return null;
    return (raw as List).map((e) => _dayFromMap(e as Map)).toList();
  }

  // --- UserInfo ---

  Future<void> saveUserInfo(UserInfo info) async {
    final box = await _open();
    await box.put('user_info', {
      'id': info.id,
      'displayName': info.displayName,
      if (info.email != null) 'email': info.email,
      'quota': {
        'used': info.quota.used,
        'total': info.quota.total,
        'relative': info.quota.relative,
        'unlimited': info.quota.unlimited,
      },
    });
  }

  Future<UserInfo?> getUserInfo() async {
    final box = await _open();
    final raw = box.get('user_info');
    if (raw == null) return null;
    final m = raw as Map;
    final q = m['quota'] as Map;
    return UserInfo(
      id: m['id'] as String,
      displayName: m['displayName'] as String,
      email: m['email'] as String?,
      quota: QuotaInfo(
        used: q['used'] as int,
        total: q['total'] as int,
        relative: (q['relative'] as num).toDouble(),
        unlimited: q['unlimited'] as bool,
      ),
    );
  }

  // --- Albums ---

  Future<void> saveAlbums(List<Album> albums) async {
    final box = await _open();
    await box.put('albums', albums.map(_albumToMap).toList());
  }

  Future<List<Album>?> getAlbums() async {
    final box = await _open();
    final raw = box.get('albums');
    if (raw == null) return null;
    return (raw as List).map((e) => _albumFromMap(e as Map)).toList();
  }

  // --- Photos per day ---

  Future<void> savePhotosForDay(int dayId, List<Photo> photos) async {
    final box = await _open();
    await box.put('day_$dayId', photos.map(_photoToMap).toList());
  }

  Future<List<Photo>?> getPhotosForDay(int dayId) async {
    final box = await _open();
    final raw = box.get('day_$dayId');
    if (raw == null) return null;
    return (raw as List).map((e) => _photoFromMap(e as Map)).toList();
  }

  // --- Photos per album ---

  Future<void> savePhotosForAlbum(String clusterId, List<Photo> photos) async {
    final box = await _open();
    await box.put('album_$clusterId', photos.map(_photoToMap).toList());
  }

  Future<List<Photo>?> getPhotosForAlbum(String clusterId) async {
    final box = await _open();
    final raw = box.get('album_$clusterId');
    if (raw == null) return null;
    return (raw as List).map((e) => _photoFromMap(e as Map)).toList();
  }

  // --- Serialization ---

  static Map<String, dynamic> _albumToMap(Album a) => {
        'clusterId': a.clusterId,
        'name': a.name,
        'count': a.count,
        'lastAddedPhoto': a.lastAddedPhoto,
        if (a.lastAddedPhotoEtag != null) 'lastAddedPhotoEtag': a.lastAddedPhotoEtag,
      };

  static Album _albumFromMap(Map m) => Album(
        clusterId: m['clusterId'] as String,
        name: m['name'] as String,
        count: m['count'] as int,
        lastAddedPhoto: m['lastAddedPhoto'] as int,
        lastAddedPhotoEtag: m['lastAddedPhotoEtag'] as String?,
      );

  static Map<String, dynamic> _dayToMap(PhotoDay d) => {
        'dayId': d.dayId,
        'count': d.count,
      };

  static PhotoDay _dayFromMap(Map m) => PhotoDay(
        dayId: m['dayId'] as int,
        count: m['count'] as int,
      );

  static Map<String, dynamic> _photoToMap(Photo p) => {
        'fileId': p.fileId,
        'dayId': p.dayId,
        'basename': p.basename,
        'epoch': p.epoch,
        'mimetype': p.mimetype,
        if (p.width != null) 'width': p.width,
        if (p.height != null) 'height': p.height,
        if (p.etag != null) 'etag': p.etag,
        if (p.auid != null) 'auid': p.auid,
        'isVideo': p.isVideo,
        'isFavorite': p.isFavorite,
        // localPath is runtime-only, never persisted
      };

  static Photo _photoFromMap(Map m) => Photo(
        fileId: m['fileId'] as int,
        dayId: m['dayId'] as int,
        basename: m['basename'] as String,
        epoch: m['epoch'] as int,
        mimetype: m['mimetype'] as String,
        width: m['width'] as int?,
        height: m['height'] as int?,
        etag: m['etag'] as String?,
        auid: m['auid'] as String?,
        isVideo: m['isVideo'] as bool? ?? false,
        isFavorite: m['isFavorite'] as bool? ?? false,
      );
}
