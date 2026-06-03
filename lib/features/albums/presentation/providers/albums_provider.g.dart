// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$albumsHash() => r'e3793cefa8e29c4fc0af86ffcccf70427795440a';

/// See also [albums].
@ProviderFor(albums)
final albumsProvider = AutoDisposeStreamProvider<List<Album>>.internal(
  albums,
  name: r'albumsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$albumsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlbumsRef = AutoDisposeStreamProviderRef<List<Album>>;
String _$albumPhotosHash() => r'bda7cfdc090d95e12d5618e62083d5586d4eb07b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [albumPhotos].
@ProviderFor(albumPhotos)
const albumPhotosProvider = AlbumPhotosFamily();

/// See also [albumPhotos].
class AlbumPhotosFamily extends Family<AsyncValue<List<Photo>>> {
  /// See also [albumPhotos].
  const AlbumPhotosFamily();

  /// See also [albumPhotos].
  AlbumPhotosProvider call(String clusterId) {
    return AlbumPhotosProvider(clusterId);
  }

  @override
  AlbumPhotosProvider getProviderOverride(
    covariant AlbumPhotosProvider provider,
  ) {
    return call(provider.clusterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'albumPhotosProvider';
}

/// See also [albumPhotos].
class AlbumPhotosProvider extends AutoDisposeStreamProvider<List<Photo>> {
  /// See also [albumPhotos].
  AlbumPhotosProvider(String clusterId)
    : this._internal(
        (ref) => albumPhotos(ref as AlbumPhotosRef, clusterId),
        from: albumPhotosProvider,
        name: r'albumPhotosProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$albumPhotosHash,
        dependencies: AlbumPhotosFamily._dependencies,
        allTransitiveDependencies: AlbumPhotosFamily._allTransitiveDependencies,
        clusterId: clusterId,
      );

  AlbumPhotosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clusterId,
  }) : super.internal();

  final String clusterId;

  @override
  Override overrideWith(
    Stream<List<Photo>> Function(AlbumPhotosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlbumPhotosProvider._internal(
        (ref) => create(ref as AlbumPhotosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clusterId: clusterId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Photo>> createElement() {
    return _AlbumPhotosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumPhotosProvider && other.clusterId == clusterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clusterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AlbumPhotosRef on AutoDisposeStreamProviderRef<List<Photo>> {
  /// The parameter `clusterId` of this provider.
  String get clusterId;
}

class _AlbumPhotosProviderElement
    extends AutoDisposeStreamProviderElement<List<Photo>>
    with AlbumPhotosRef {
  _AlbumPhotosProviderElement(super.provider);

  @override
  String get clusterId => (origin as AlbumPhotosProvider).clusterId;
}

String _$removePhotosFromAlbumHash() =>
    r'554c03ccb6350bf81d75fdc545f7c93e8c85e05b';

/// See also [RemovePhotosFromAlbum].
@ProviderFor(RemovePhotosFromAlbum)
final removePhotosFromAlbumProvider =
    AutoDisposeAsyncNotifierProvider<RemovePhotosFromAlbum, void>.internal(
      RemovePhotosFromAlbum.new,
      name: r'removePhotosFromAlbumProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$removePhotosFromAlbumHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RemovePhotosFromAlbum = AutoDisposeAsyncNotifier<void>;
String _$addPhotosToAlbumHash() => r'5cc0cf2ee2948f7d2f519d0ee4dc1dbe42a87e46';

/// See also [AddPhotosToAlbum].
@ProviderFor(AddPhotosToAlbum)
final addPhotosToAlbumProvider =
    AutoDisposeAsyncNotifierProvider<AddPhotosToAlbum, void>.internal(
      AddPhotosToAlbum.new,
      name: r'addPhotosToAlbumProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addPhotosToAlbumHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddPhotosToAlbum = AutoDisposeAsyncNotifier<void>;
String _$deleteAlbumHash() => r'ac6504d5b2de2f84f700060a763bb70976e0000f';

/// See also [DeleteAlbum].
@ProviderFor(DeleteAlbum)
final deleteAlbumProvider =
    AutoDisposeAsyncNotifierProvider<DeleteAlbum, void>.internal(
      DeleteAlbum.new,
      name: r'deleteAlbumProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteAlbumHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeleteAlbum = AutoDisposeAsyncNotifier<void>;
String _$createAlbumHash() => r'a46a48faf772ecae98ca454b543fd74aee505888';

/// See also [CreateAlbum].
@ProviderFor(CreateAlbum)
final createAlbumProvider =
    AutoDisposeAsyncNotifierProvider<CreateAlbum, void>.internal(
      CreateAlbum.new,
      name: r'createAlbumProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createAlbumHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CreateAlbum = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
