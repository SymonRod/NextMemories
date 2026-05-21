// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServerConfigModelImpl _$$ServerConfigModelImplFromJson(
  Map<String, dynamic> json,
) => _$ServerConfigModelImpl(
  serverUrl: json['serverUrl'] as String,
  username: json['username'] as String,
  appPassword: json['appPassword'] as String,
);

Map<String, dynamic> _$$ServerConfigModelImplToJson(
  _$ServerConfigModelImpl instance,
) => <String, dynamic>{
  'serverUrl': instance.serverUrl,
  'username': instance.username,
  'appPassword': instance.appPassword,
};
