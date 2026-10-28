import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/features/onboarding/data/models/user_record.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

abstract final class UserProfileMapper {
  static UserProfile toDomain(UserRecord row) => UserProfile(
    id: row.userId,
    displayName: row.displayName,
    sexForCalculation: row.sexForCalculation,
    birthDate: row.birthDate,
    heightCm: row.heightCm,
    weightKg: row.weightKg,
    targetWeightKg: row.targetWeightKg,
    goal: row.goal,
    activityLevel: row.activityLevel,
    allergies: row.allergies,
    chronicConditions: row.chronicConditions,
    timezone: row.timezone,
    updatedAt: row.updatedAt,
  );

  static UserRecord toRecord(UserProfile model, {int? localId}) => UserRecord()
    ..id = localId ?? Isar.autoIncrement
    ..userId = model.id
    ..displayName = model.displayName
    ..sexForCalculation = model.sexForCalculation
    ..birthDate = model.birthDate
    ..heightCm = model.heightCm
    ..weightKg = model.weightKg
    ..targetWeightKg = model.targetWeightKg
    ..goal = model.goal
    ..activityLevel = model.activityLevel
    ..allergies = model.allergies.toList()
    ..chronicConditions = model.chronicConditions.toList()
    ..timezone = model.timezone
    ..updatedAt = model.updatedAt;
}
