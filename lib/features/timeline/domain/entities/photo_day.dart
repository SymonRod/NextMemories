import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_day.freezed.dart';

@freezed
class PhotoDay with _$PhotoDay {
  const factory PhotoDay({
    required int dayId,
    required int count,
  }) = _PhotoDay;
}
