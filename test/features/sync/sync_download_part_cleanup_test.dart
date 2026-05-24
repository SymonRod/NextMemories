import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:next_memories/features/auth/domain/entities/server_config.dart';
import 'package:next_memories/features/sync/data/datasources/sync_download_datasource.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Stub minimo per path_provider in ambiente test
class _FakePathProvider
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String dir;
  _FakePathProvider(this.dir);

  @override
  Future<String?> getApplicationDocumentsPath() async => dir;

  // Gli altri metodi non sono usati da questo datasource
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  late Directory tempDir;
  late SyncDownloadDatasource ds;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sync_test_');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);

    ds = SyncDownloadDatasource(const ServerConfig(
      serverUrl: 'https://example.com',
      username: 'user',
      appPassword: 'pass',
    ));
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('cleanupPartFiles rimuove i .part residui e lascia gli altri file intatti', () async {
    final syncDir = Directory(p.join(tempDir.path, 'sync'));
    await syncDir.create(recursive: true);

    // Crea file residui da sync interrotta
    final part1 = File(p.join(syncDir.path, '123.jpg.part'));
    final part2 = File(p.join(syncDir.path, '456.mp4.part'));
    final good = File(p.join(syncDir.path, '789.jpg'));

    await part1.writeAsString('partial data');
    await part2.writeAsString('partial data');
    await good.writeAsString('complete file');

    await ds.cleanupPartFiles();

    expect(await part1.exists(), false, reason: '123.jpg.part deve essere eliminato');
    expect(await part2.exists(), false, reason: '456.mp4.part deve essere eliminato');
    expect(await good.exists(), true, reason: '789.jpg non deve essere toccato');
  });

  test('cleanupPartFiles è idempotente quando non ci sono .part', () async {
    final syncDir = Directory(p.join(tempDir.path, 'sync'));
    await syncDir.create(recursive: true);

    await expectLater(ds.cleanupPartFiles(), completes);
  });
}
