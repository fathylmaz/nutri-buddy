import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';
import 'package:nutri_buddy/features/meal_builder/domain/usecases/recipe_allergen_guard.dart';

final validRecipe = <String, dynamic>{
  'name': 'Fıstıklı pilav',
  'description': 'Pratik bir yemek',
  'ingredients': [
    {'name': 'Yer fıstığı', 'quantity': '1 avuç', 'grams': 25},
    {'name': 'Pirinç', 'quantity': '1 çay bardağı', 'grams': 90},
  ],
  'steps': ['Pirinci yıka.', 'Malzemeleri pişir.'],
  'prep_minutes': 30,
  'calories_kcal': 420,
  'protein_g': 12,
  'carbs_g': 56,
  'fat_g': 17,
  'fiber_g': 3,
  'caution': 'Besin değerleri tahminidir.',
};

void main() {
  test('valid recipe survives JSON snapshot roundtrip', () {
    final recipe = MealRecipe.fromJson(validRecipe);
    final after = MealRecipe.fromJson(recipe.toJson());
    expect(after.name, recipe.name);
    expect(after.steps, recipe.steps);
    expect(after.ingredients.first.grams, 25);
    expect(after.caloriesKcal, 420);
  });

  test('rejects oversized or missing generated nutrition and instructions', () {
    expect(
      () => MealRecipe.fromJson({...validRecipe, 'calories_kcal': -1}),
      throwsFormatException,
    );
    expect(
      () => MealRecipe.fromJson({...validRecipe, 'steps': []}),
      throwsFormatException,
    );
    expect(
      () => MealRecipe.fromJson({...validRecipe, 'protein_g': double.infinity}),
      throwsFormatException,
    );
  });

  test('flags explicit allergy terms; does not claim clinical safety', () {
    final recipe = MealRecipe.fromJson(validRecipe);
    expect(
      RecipeAllergenGuard.firstExplicitMatch(recipe, ['fıstık']),
      'fıstık',
    );
    expect(RecipeAllergenGuard.firstExplicitMatch(recipe, ['karides']), isNull);
  });
}
