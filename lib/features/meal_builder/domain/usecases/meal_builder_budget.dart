import 'dart:math' as math;

import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

/// A planning hint, not a maximum allowed intake or medical prescription.
class MealBuilderBudget {
  const MealBuilderBudget({
    required this.remainingKcal,
    required this.remainingProteinG,
    required this.remainingCarbsG,
    required this.remainingFatG,
  });

  final int remainingKcal;
  final double remainingProteinG;
  final double remainingCarbsG;
  final double remainingFatG;

  factory MealBuilderBudget.fromDay({
    required NutritionTargets targets,
    required DailyNutritionSummary consumed,
  }) => MealBuilderBudget(
    remainingKcal: math.max(0, targets.dailyCalories - consumed.caloriesKcal),
    remainingProteinG: math.max(0, targets.proteinG - consumed.proteinG),
    remainingCarbsG: math.max(0, targets.carbsG - consumed.carbsG),
    remainingFatG: math.max(0, targets.fatG - consumed.fatG),
  );

  /// Provides an affordable per-meal target, bounded by today's remainder.
  int targetFor(String mealType) {
    final suggested = switch (mealType) {
      'breakfast' => 450,
      'lunch' => 650,
      'dinner' => 650,
      'snack' => 250,
      _ => 500,
    };
    return math.min(remainingKcal, suggested);
  }
}
