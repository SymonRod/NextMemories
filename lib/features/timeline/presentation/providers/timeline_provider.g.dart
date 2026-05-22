// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineDaysHash() => r'3eb07e46e1d657e5fc644a3cef64f28611298088';

/// See also [timelineDays].
@ProviderFor(timelineDays)
final timelineDaysProvider = AutoDisposeFutureProvider<List<PhotoDay>>.internal(
  timelineDays,
  name: r'timelineDaysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineDaysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimelineDaysRef = AutoDisposeFutureProviderRef<List<PhotoDay>>;
String _$dayPhotosHash() => r'f5791d5be6cb1c905de6d3d01f43b7230ffcc587';

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

/// See also [dayPhotos].
@ProviderFor(dayPhotos)
const dayPhotosProvider = DayPhotosFamily();

/// See also [dayPhotos].
class DayPhotosFamily extends Family<AsyncValue<List<Photo>>> {
  /// See also [dayPhotos].
  const DayPhotosFamily();

  /// See also [dayPhotos].
  DayPhotosProvider call(int dayId) {
    return DayPhotosProvider(dayId);
  }

  @override
  DayPhotosProvider getProviderOverride(covariant DayPhotosProvider provider) {
    return call(provider.dayId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dayPhotosProvider';
}

/// See also [dayPhotos].
class DayPhotosProvider extends AutoDisposeFutureProvider<List<Photo>> {
  /// See also [dayPhotos].
  DayPhotosProvider(int dayId)
    : this._internal(
        (ref) => dayPhotos(ref as DayPhotosRef, dayId),
        from: dayPhotosProvider,
        name: r'dayPhotosProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dayPhotosHash,
        dependencies: DayPhotosFamily._dependencies,
        allTransitiveDependencies: DayPhotosFamily._allTransitiveDependencies,
        dayId: dayId,
      );

  DayPhotosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dayId,
  }) : super.internal();

  final int dayId;

  @override
  Override overrideWith(
    FutureOr<List<Photo>> Function(DayPhotosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DayPhotosProvider._internal(
        (ref) => create(ref as DayPhotosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dayId: dayId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Photo>> createElement() {
    return _DayPhotosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DayPhotosProvider && other.dayId == dayId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dayId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DayPhotosRef on AutoDisposeFutureProviderRef<List<Photo>> {
  /// The parameter `dayId` of this provider.
  int get dayId;
}

class _DayPhotosProviderElement
    extends AutoDisposeFutureProviderElement<List<Photo>>
    with DayPhotosRef {
  _DayPhotosProviderElement(super.provider);

  @override
  int get dayId => (origin as DayPhotosProvider).dayId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
