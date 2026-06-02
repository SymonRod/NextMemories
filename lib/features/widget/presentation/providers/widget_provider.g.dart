// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$widgetRepositoryHash() => r'ecb6e0625c10d835b06e8364125b2f55fac05aa2';

/// See also [widgetRepository].
@ProviderFor(widgetRepository)
final widgetRepositoryProvider = Provider<IWidgetRepository>.internal(
  widgetRepository,
  name: r'widgetRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$widgetRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WidgetRepositoryRef = ProviderRef<IWidgetRepository>;
String _$pinnedAlbumWidgetHash() => r'aa066123ddd878b645e43cd8ca44ee69880b9774';

/// See also [PinnedAlbumWidget].
@ProviderFor(PinnedAlbumWidget)
final pinnedAlbumWidgetProvider =
    AutoDisposeAsyncNotifierProvider<
      PinnedAlbumWidget,
      WidgetAlbumConfig?
    >.internal(
      PinnedAlbumWidget.new,
      name: r'pinnedAlbumWidgetProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pinnedAlbumWidgetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PinnedAlbumWidget = AutoDisposeAsyncNotifier<WidgetAlbumConfig?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
