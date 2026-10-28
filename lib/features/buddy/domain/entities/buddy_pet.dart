import 'package:freezed_annotation/freezed_annotation.dart';

part 'buddy_pet.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class BuddyPet with _$BuddyPet {
  const factory BuddyPet({
    required String id,
    required String userId,
    @Default('neutral') String mood,
    @Default(0) int xp,
    @Default(0) int gold,
    @Default(1) int level,
    @Default(0) int streakDays,
    required DateTime updatedAt,
  }) = _BuddyPet;
}
