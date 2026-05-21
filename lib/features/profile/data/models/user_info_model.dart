// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

double _parseDouble(dynamic value) => (value as num).toDouble();
int _parseInt(dynamic value) => (value as num).toInt();

@freezed
class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    required String id,
    @JsonKey(name: 'display-name') required String displayName,
    String? email,
    required QuotaInfoModel quota,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}

@freezed
class QuotaInfoModel with _$QuotaInfoModel {
  const factory QuotaInfoModel({
    @JsonKey(fromJson: _parseInt) required int used,
    @JsonKey(fromJson: _parseInt) required int total,
    @JsonKey(fromJson: _parseDouble) required double relative,
    @JsonKey(fromJson: _parseInt) required int quota,
  }) = _QuotaInfoModel;

  factory QuotaInfoModel.fromJson(Map<String, dynamic> json) =>
      _$QuotaInfoModelFromJson(json);
}

