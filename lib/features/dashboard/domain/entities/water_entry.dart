import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_entry.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class WaterEntry with _$WaterEntry {
  const factory WaterEntry({
    required String id,
    required String userId,
    required int amountMl,
    required DateTime recordedAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _WaterEntry;
}
