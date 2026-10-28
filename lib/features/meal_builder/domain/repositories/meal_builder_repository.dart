import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';
import 'package:nutri_buddy/features/meal_builder/domain/usecases/meal_builder_budget.dart';

class MealBuilderRequest {
  const MealBuilderRequest({
    required this.mealType,
    required this.budget,
    required this.pantry,
    required this.exclusions,
    required this.dietStyle,
    required this.count,
    this.avoidNames = const [],
  });

  final String mealType;
  final MealBuilderBudget budget;
  final List<String> pantry;
  final List<String> exclusions;
  final String dietStyle;
  final int count;
  final List<String> avoidNames;

  Map<String, dynamic> toJson() => {
    'meal_type': mealType,
    'remaining_kcal': budget.remainingKcal,
    'remaining_protein_g': budget.remainingProteinG.round(),
    'remaining_carbs_g': budget.remainingCarbsG.round(),
    'remaining_fat_g': budget.remainingFatG.round(),
    'target_kcal': budget.targetFor(mealType),
    'pantry': pantry,
    'exclusions': exclusions,
    'diet_style': dietStyle,
    'count': count,
    'avoid_names': avoidNames,
  };
}

abstract interface class MealBuilderRepository {
  Future<List<MealRecipe>> generate(MealBuilderRequest request);
}
