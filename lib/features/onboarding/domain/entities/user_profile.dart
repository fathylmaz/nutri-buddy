import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    String? displayName,
    String? sexForCalculation,
    DateTime? birthDate,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    String? goal,
    String? activityLevel,
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> chronicConditions,
    @Default('UTC') String timezone,
    required DateTime updatedAt,
  }) = _UserProfile;
}
