import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/meal_builder/domain/usecases/meal_builder_budget.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

void main() {
  test('remaining budget follows logged food and respects 0 floor', () {
    const targets = NutritionTargets(
      bmrKcal: 1600,
      tdeeKcal: 2300,
      dailyCalories: 2000,
      proteinG: 125,
      carbsG: 225,
      fatG: 56,
    );
    const consumed = DailyNutritionSummary(
      caloriesKcal: 1780,
      proteinG: 130,
      carbsG: 120,
      fatG: 58,
      mealCount: 3,
    );
    final result = MealBuilderBudget.fromDay(
      targets: targets,
      consumed: consumed,
    );
    expect(result.remainingKcal, 220);
    expect(result.remainingProteinG, 0);
    expect(result.remainingCarbsG, 105);
    expect(result.remainingFatG, 0);
    expect(result.targetFor('dinner'), 220);
    expect(result.targetFor('snack'), 220);
  });

  test('per-meal hints never exceed remaining daily calories', () {
    const budget = MealBuilderBudget(
      remainingKcal: 1000,
      remainingProteinG: 45,
      remainingCarbsG: 100,
      remainingFatG: 20,
    );
    expect(budget.targetFor('breakfast'), 450);
    expect(budget.targetFor('lunch'), 650);
    expect(budget.targetFor('snack'), 250);
  });
}
