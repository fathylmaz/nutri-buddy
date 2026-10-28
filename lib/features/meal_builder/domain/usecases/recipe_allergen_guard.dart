import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';

/// This catches explicit matches only. It cannot detect hidden ingredients,
/// derivatives, preparation cross-contact, or translation synonyms.
abstract final class RecipeAllergenGuard {
  static String? firstExplicitMatch(
    MealRecipe recipe,
    List<String> exclusions,
  ) {
    final searchable = <String>[
      recipe.name,
      ...recipe.ingredients.map((e) => e.name),
      ...recipe.ingredients.map((e) => e.quantity),
      ...recipe.steps,
    ].map(_normalize).toList();
    for (final term in exclusions) {
      final needle = _normalize(term);
      if (needle.length < 2) {
        continue;
      }
      for (final value in searchable) {
        if (value.contains(needle)) {
          return term;
        }
      }
    }
    return null;
  }

  static String _normalize(String value) => value
      .toLowerCase()
      .replaceAll('İ', 'i')
      .replaceAll('ı', 'i')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .trim();
}
