// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoDayModelImpl _$$PhotoDayModelImplFromJson(Map<String, dynamic> json) =>
    _$PhotoDayModelImpl(
      dayId: (json['dayid'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      detail: (json['detail'] as List<dynamic>?)
          ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PhotoDayModelImplToJson(_$PhotoDayModelImpl instance) =>
    <String, dynamic>{
      'dayid': instance.dayId,
      'count': instance.count,
      'detail': instance.detail,
    };
