import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutri_buddy/features/meals/domain/entities/vision_meal_analysis.dart';

part 'meal_log.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class MealLog with _$MealLog {
  const factory MealLog({
    required String id,
    required String userId,
    required DateTime loggedAt,
    required String name,
    @Default('other') String mealType,
    @Default('manual') String source,
    @Default(0) int caloriesKcal,
    @Default(0) double proteinG,
    @Default(0) double carbsG,
    @Default(0) double fatG,
    @Default(0) double fiberG,
    @Default(true) bool isEstimate,
    VisionMealAnalysis? visionAnalysis,

    /// JSON snapshot of an accepted AI recipe; null for other meal sources.
    String? recipeDetailsJson,
    @Default(false) bool isDeleted,
    required DateTime updatedAt,
  }) = _MealLog;
}
