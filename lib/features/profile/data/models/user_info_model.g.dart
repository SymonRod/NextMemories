// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoModelImpl _$$UserInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoModelImpl(
      id: json['id'] as String,
      displayName: json['display-name'] as String,
      email: json['email'] as String?,
      quota: QuotaInfoModel.fromJson(json['quota'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserInfoModelImplToJson(_$UserInfoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display-name': instance.displayName,
      'email': instance.email,
      'quota': instance.quota,
    };

_$QuotaInfoModelImpl _$$QuotaInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$QuotaInfoModelImpl(
      used: _parseInt(json['used']),
      total: _parseInt(json['total']),
      relative: _parseDouble(json['relative']),
      quota: _parseInt(json['quota']),
    );

Map<String, dynamic> _$$QuotaInfoModelImplToJson(
  _$QuotaInfoModelImpl instance,
) => <String, dynamic>{
  'used': instance.used,
  'total': instance.total,
  'relative': instance.relative,
  'quota': instance.quota,
};
