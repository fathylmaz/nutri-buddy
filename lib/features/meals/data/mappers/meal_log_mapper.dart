import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/features/meals/data/mappers/vision_meal_analysis_mapper.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';

abstract final class MealLogMapper {
  static MealLogRecord toRecord(MealLog value, {int? localId}) {
    return MealLogRecord()
      ..id = localId ?? Isar.autoIncrement
      ..recordId = value.id
      ..userId = value.userId
      ..loggedAt = value.loggedAt.toUtc()
      ..name = value.name
      ..mealType = value.mealType
      ..source = value.source
      ..caloriesKcal = value.caloriesKcal
      ..proteinG = value.proteinG
      ..carbsG = value.carbsG
      ..fatG = value.fatG
      ..fiberG = value.fiberG
      ..isEstimate = value.isEstimate
      ..visionDetailsJson = (value.visionAnalysis == null
          ? null
          : jsonEncode(VisionMealAnalysisMapper.toJson(value.visionAnalysis!)))
      ..recipeDetailsJson = value.recipeDetailsJson
      ..isDeleted = value.isDeleted
      ..updatedAt = value.updatedAt.toUtc()
      ..pendingSync = true;
  }

  static MealLog toDomain(MealLogRecord record) => MealLog(
    id: record.recordId,
    userId: record.userId,
    loggedAt: record.loggedAt.toUtc(),
    name: record.name,
    mealType: record.mealType,
    source: record.source,
    caloriesKcal: record.caloriesKcal,
    proteinG: record.proteinG,
    carbsG: record.carbsG,
    fatG: record.fatG,
    fiberG: record.fiberG,
    isEstimate: record.isEstimate,
    visionAnalysis: record.visionDetailsJson == null
        ? null
        : VisionMealAnalysisMapper.fromJson(
            Map<String, dynamic>.from(
              jsonDecode(record.visionDetailsJson!) as Map,
            ),
          ),
    recipeDetailsJson: record.recipeDetailsJson,
    isDeleted: record.isDeleted,
    updatedAt: record.updatedAt.toUtc(),
  );
}
