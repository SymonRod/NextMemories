import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';

@freezed
class UserInfo with _$UserInfo {
  const UserInfo._();

  const factory UserInfo({
    required String id,
    required String displayName,
    String? email,
    required QuotaInfo quota,
  }) = _UserInfo;
}

@freezed
class QuotaInfo with _$QuotaInfo {
  const QuotaInfo._();

  const factory QuotaInfo({
    required int used,
    required int total,
    required double relative,
    required bool unlimited,
  }) = _QuotaInfo;

  double get progressValue =>
      unlimited ? 0.0 : (relative / 100.0).clamp(0.0, 1.0);
}
