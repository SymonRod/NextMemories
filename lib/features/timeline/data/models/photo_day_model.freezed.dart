// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_day_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhotoDayModel _$PhotoDayModelFromJson(Map<String, dynamic> json) {
  return _PhotoDayModel.fromJson(json);
}

/// @nodoc
mixin _$PhotoDayModel {
  @JsonKey(name: 'dayid')
  int get dayId => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<PhotoModel>? get detail => throw _privateConstructorUsedError;

  /// Serializes this PhotoDayModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoDayModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoDayModelCopyWith<PhotoDayModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoDayModelCopyWith<$Res> {
  factory $PhotoDayModelCopyWith(
    PhotoDayModel value,
    $Res Function(PhotoDayModel) then,
  ) = _$PhotoDayModelCopyWithImpl<$Res, PhotoDayModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'dayid') int dayId,
    int count,
    List<PhotoModel>? detail,
  });
}

/// @nodoc
class _$PhotoDayModelCopyWithImpl<$Res, $Val extends PhotoDayModel>
    implements $PhotoDayModelCopyWith<$Res> {
  _$PhotoDayModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoDayModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayId = null,
    Object? count = null,
    Object? detail = freezed,
  }) {
    return _then(
      _value.copyWith(
            dayId: null == dayId
                ? _value.dayId
                : dayId // ignore: cast_nullable_to_non_nullable
                      as int,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            detail: freezed == detail
                ? _value.detail
                : detail // ignore: cast_nullable_to_non_nullable
                      as List<PhotoModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhotoDayModelImplCopyWith<$Res>
    implements $PhotoDayModelCopyWith<$Res> {
  factory _$$PhotoDayModelImplCopyWith(
    _$PhotoDayModelImpl value,
    $Res Function(_$PhotoDayModelImpl) then,
  ) = __$$PhotoDayModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'dayid') int dayId,
    int count,
    List<PhotoModel>? detail,
  });
}

/// @nodoc
class __$$PhotoDayModelImplCopyWithImpl<$Res>
    extends _$PhotoDayModelCopyWithImpl<$Res, _$PhotoDayModelImpl>
    implements _$$PhotoDayModelImplCopyWith<$Res> {
  __$$PhotoDayModelImplCopyWithImpl(
    _$PhotoDayModelImpl _value,
    $Res Function(_$PhotoDayModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoDayModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayId = null,
    Object? count = null,
    Object? detail = freezed,
  }) {
    return _then(
      _$PhotoDayModelImpl(
        dayId: null == dayId
            ? _value.dayId
            : dayId // ignore: cast_nullable_to_non_nullable
                  as int,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        detail: freezed == detail
            ? _value._detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as List<PhotoModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoDayModelImpl implements _PhotoDayModel {
  const _$PhotoDayModelImpl({
    @JsonKey(name: 'dayid') required this.dayId,
    required this.count,
    final List<PhotoModel>? detail,
  }) : _detail = detail;

  factory _$PhotoDayModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoDayModelImplFromJson(json);

  @override
  @JsonKey(name: 'dayid')
  final int dayId;
  @override
  final int count;
  final List<PhotoModel>? _detail;
  @override
  List<PhotoModel>? get detail {
    final value = _detail;
    if (value == null) return null;
    if (_detail is EqualUnmodifiableListView) return _detail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PhotoDayModel(dayId: $dayId, count: $count, detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoDayModelImpl &&
            (identical(other.dayId, dayId) || other.dayId == dayId) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._detail, _detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dayId,
    count,
    const DeepCollectionEquality().hash(_detail),
  );

  /// Create a copy of PhotoDayModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoDayModelImplCopyWith<_$PhotoDayModelImpl> get copyWith =>
      __$$PhotoDayModelImplCopyWithImpl<_$PhotoDayModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoDayModelImplToJson(this);
  }
}

abstract class _PhotoDayModel implements PhotoDayModel {
  const factory _PhotoDayModel({
    @JsonKey(name: 'dayid') required final int dayId,
    required final int count,
    final List<PhotoModel>? detail,
  }) = _$PhotoDayModelImpl;

  factory _PhotoDayModel.fromJson(Map<String, dynamic> json) =
      _$PhotoDayModelImpl.fromJson;

  @override
  @JsonKey(name: 'dayid')
  int get dayId;
  @override
  int get count;
  @override
  List<PhotoModel>? get detail;

  /// Create a copy of PhotoDayModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoDayModelImplCopyWith<_$PhotoDayModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
