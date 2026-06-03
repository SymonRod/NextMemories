// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoInfoHash() => r'f6bdfabfc1c887fc28d3f8df68ced8859f25c1c9';

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

abstract class _$PhotoInfo
    extends BuildlessAutoDisposeAsyncNotifier<PhotoInfoModel> {
  late final int fileId;

  FutureOr<PhotoInfoModel> build(int fileId);
}

/// See also [PhotoInfo].
@ProviderFor(PhotoInfo)
const photoInfoProvider = PhotoInfoFamily();

/// See also [PhotoInfo].
class PhotoInfoFamily extends Family<AsyncValue<PhotoInfoModel>> {
  /// See also [PhotoInfo].
  const PhotoInfoFamily();

  /// See also [PhotoInfo].
  PhotoInfoProvider call(int fileId) {
    return PhotoInfoProvider(fileId);
  }

  @override
  PhotoInfoProvider getProviderOverride(covariant PhotoInfoProvider provider) {
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
  String? get name => r'photoInfoProvider';
}

/// See also [PhotoInfo].
class PhotoInfoProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PhotoInfo, PhotoInfoModel> {
  /// See also [PhotoInfo].
  PhotoInfoProvider(int fileId)
    : this._internal(
        () => PhotoInfo()..fileId = fileId,
        from: photoInfoProvider,
        name: r'photoInfoProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$photoInfoHash,
        dependencies: PhotoInfoFamily._dependencies,
        allTransitiveDependencies: PhotoInfoFamily._allTransitiveDependencies,
        fileId: fileId,
      );

  PhotoInfoProvider._internal(
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
  FutureOr<PhotoInfoModel> runNotifierBuild(covariant PhotoInfo notifier) {
    return notifier.build(fileId);
  }

  @override
  Override overrideWith(PhotoInfo Function() create) {
    return ProviderOverride(
      origin: this,
      override: PhotoInfoProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PhotoInfo, PhotoInfoModel>
  createElement() {
    return _PhotoInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoInfoProvider && other.fileId == fileId;
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
mixin PhotoInfoRef on AutoDisposeAsyncNotifierProviderRef<PhotoInfoModel> {
  /// The parameter `fileId` of this provider.
  int get fileId;
}

class _PhotoInfoProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PhotoInfo, PhotoInfoModel>
    with PhotoInfoRef {
  _PhotoInfoProviderElement(super.provider);

  @override
  int get fileId => (origin as PhotoInfoProvider).fileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
