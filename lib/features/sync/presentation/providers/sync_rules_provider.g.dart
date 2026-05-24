// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_rules_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncRepositoryHash() => r'1a5f40f3f954378fef79c78bd2180f31af97d1e2';

/// See also [syncRepository].
@ProviderFor(syncRepository)
final syncRepositoryProvider = Provider<ISyncRepository>.internal(
  syncRepository,
  name: r'syncRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncRepositoryRef = ProviderRef<ISyncRepository>;
String _$syncRuleStatsHash() => r'c7a2b0e2bab30613a807c583f4994bea29a951b5';

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

/// See also [syncRuleStats].
@ProviderFor(syncRuleStats)
const syncRuleStatsProvider = SyncRuleStatsFamily();

/// See also [syncRuleStats].
class SyncRuleStatsFamily
    extends Family<AsyncValue<({int fileCount, int sizeBytes})>> {
  /// See also [syncRuleStats].
  const SyncRuleStatsFamily();

  /// See also [syncRuleStats].
  SyncRuleStatsProvider call(int ruleId) {
    return SyncRuleStatsProvider(ruleId);
  }

  @override
  SyncRuleStatsProvider getProviderOverride(
    covariant SyncRuleStatsProvider provider,
  ) {
    return call(provider.ruleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'syncRuleStatsProvider';
}

/// See also [syncRuleStats].
class SyncRuleStatsProvider
    extends AutoDisposeFutureProvider<({int fileCount, int sizeBytes})> {
  /// See also [syncRuleStats].
  SyncRuleStatsProvider(int ruleId)
    : this._internal(
        (ref) => syncRuleStats(ref as SyncRuleStatsRef, ruleId),
        from: syncRuleStatsProvider,
        name: r'syncRuleStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$syncRuleStatsHash,
        dependencies: SyncRuleStatsFamily._dependencies,
        allTransitiveDependencies:
            SyncRuleStatsFamily._allTransitiveDependencies,
        ruleId: ruleId,
      );

  SyncRuleStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ruleId,
  }) : super.internal();

  final int ruleId;

  @override
  Override overrideWith(
    FutureOr<({int fileCount, int sizeBytes})> Function(
      SyncRuleStatsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SyncRuleStatsProvider._internal(
        (ref) => create(ref as SyncRuleStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ruleId: ruleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<({int fileCount, int sizeBytes})>
  createElement() {
    return _SyncRuleStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SyncRuleStatsProvider && other.ruleId == ruleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ruleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SyncRuleStatsRef
    on AutoDisposeFutureProviderRef<({int fileCount, int sizeBytes})> {
  /// The parameter `ruleId` of this provider.
  int get ruleId;
}

class _SyncRuleStatsProviderElement
    extends AutoDisposeFutureProviderElement<({int fileCount, int sizeBytes})>
    with SyncRuleStatsRef {
  _SyncRuleStatsProviderElement(super.provider);

  @override
  int get ruleId => (origin as SyncRuleStatsProvider).ruleId;
}

String _$syncTotalCacheBytesHash() =>
    r'1fdc07f499e3102e938834f3a20189e5a8e648ce';

/// See also [syncTotalCacheBytes].
@ProviderFor(syncTotalCacheBytes)
final syncTotalCacheBytesProvider = AutoDisposeFutureProvider<int>.internal(
  syncTotalCacheBytes,
  name: r'syncTotalCacheBytesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncTotalCacheBytesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncTotalCacheBytesRef = AutoDisposeFutureProviderRef<int>;
String _$syncRulesHash() => r'408ddf517fbe5f16bec49a8704bf541eb27a7027';

/// See also [SyncRules].
@ProviderFor(SyncRules)
final syncRulesProvider =
    AutoDisposeAsyncNotifierProvider<SyncRules, List<SyncRule>>.internal(
      SyncRules.new,
      name: r'syncRulesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncRulesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncRules = AutoDisposeAsyncNotifier<List<SyncRule>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
