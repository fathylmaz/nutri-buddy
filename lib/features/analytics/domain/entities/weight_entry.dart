import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_entry.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class WeightEntry with _$WeightEntry {
  const factory WeightEntry({
    required String id,
    required String userId,
    required double weightKg,
    required DateTime recordedAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _WeightEntry;
}
