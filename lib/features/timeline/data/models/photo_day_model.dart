import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/photo_day.dart';
import 'photo_model.dart';

part 'photo_day_model.freezed.dart';
part 'photo_day_model.g.dart';

@freezed
class PhotoDayModel with _$PhotoDayModel {
  const factory PhotoDayModel({
    @JsonKey(name: 'dayid') required int dayId,
    required int count,
    List<PhotoModel>? detail,
  }) = _PhotoDayModel;

  factory PhotoDayModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoDayModelFromJson(json);
}

extension PhotoDayModelX on PhotoDayModel {
  PhotoDay toEntity() => PhotoDay(dayId: dayId, count: count);
}
