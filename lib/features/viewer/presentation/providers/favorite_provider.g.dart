// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteHash() => r'3b897cb49da74b7d287b317753da1f07ac63a168';

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

abstract class _$Favorite extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final int fileId;

  FutureOr<bool> build(int fileId);
}

/// See also [Favorite].
@ProviderFor(Favorite)
const favoriteProvider = FavoriteFamily();

/// See also [Favorite].
class FavoriteFamily extends Family<AsyncValue<bool>> {
  /// See also [Favorite].
  const FavoriteFamily();

  /// See also [Favorite].
  FavoriteProvider call(int fileId) {
    return FavoriteProvider(fileId);
  }

  @override
  FavoriteProvider getProviderOverride(covariant FavoriteProvider provider) {
    return call(provider.fileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'favoriteProvider';
}

/// See also [Favorite].
class FavoriteProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Favorite, bool> {
  /// See also [Favorite].
  FavoriteProvider(int fileId)
    : this._internal(
        () => Favorite()..fileId = fileId,
        from: favoriteProvider,
        name: r'favoriteProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$favoriteHash,
        dependencies: FavoriteFamily._dependencies,
        allTransitiveDependencies: FavoriteFamily._allTransitiveDependencies,
        fileId: fileId,
      );

  FavoriteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.fileId,
  }) : super.internal();

  final int fileId;

  @override
  FutureOr<bool> runNotifierBuild(covariant Favorite notifier) {
    return notifier.build(fileId);
  }

  @override
  Override overrideWith(Favorite Function() create) {
    return ProviderOverride(
      origin: this,
      override: FavoriteProvider._internal(
        () => create()..fileId = fileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        fileId: fileId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Favorite, bool> createElement() {
    return _FavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteProvider && other.fileId == fileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, fileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FavoriteRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `fileId` of this provider.
  int get fileId;
}

class _FavoriteProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Favorite, bool>
    with FavoriteRef {
  _FavoriteProviderElement(super.provider);

  @override
  int get fileId => (origin as FavoriteProvider).fileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
