/// An unverified AI recipe suggestion. Not a clinically validated meal plan.
class RecipeIngredient {
  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.grams,
  });

  final String name;
  final String quantity;
  final double grams;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    final name = _text(json['name'], 100);
    final quantity = _text(json['quantity'], 90);
    final grams = _amount(json['grams'], 3000);
    if (name.isEmpty || quantity.isEmpty) {
      throw const FormatException('Tarif malzemesi eksik.');
    }
    return RecipeIngredient(name: name, quantity: quantity, grams: grams);
  }
}

class MealRecipe {
  MealRecipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.prepMinutes,
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.caution,
  });

  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final int prepMinutes;
  final int caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final String caution;

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'ingredients': [
      for (final item in ingredients)
        {'name': item.name, 'quantity': item.quantity, 'grams': item.grams},
    ],
    'steps': steps,
    'prep_minutes': prepMinutes,
    'calories_kcal': caloriesKcal,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'fiber_g': fiberG,
    'caution': caution,
  };

  factory MealRecipe.fromJson(Map<String, dynamic> json) {
    final name = _text(json['name'], 120);
    final description = _text(json['description'], 500);
    final caution = _text(json['caution'], 500);
    final ingredientList = json['ingredients'];
    final stepList = json['steps'];
    if (name.isEmpty ||
        description.isEmpty ||
        ingredientList is! List ||
        ingredientList.isEmpty ||
        ingredientList.length > 20 ||
        stepList is! List ||
        stepList.isEmpty ||
        stepList.length > 12) {
      throw const FormatException(
        'Gemini geçersiz tarif ayrıntıları gönderdi.',
      );
    }
    final ingredients = ingredientList
        .map((e) {
          if (e is! Map) {
            throw const FormatException('Malzeme biçimi geçersiz.');
          }
          return RecipeIngredient.fromJson(Map<String, dynamic>.from(e));
        })
        .toList(growable: false);
    final steps = stepList
        .map((step) {
          final result = _text(step, 400);
          if (result.isEmpty) {
            throw const FormatException('Tarif adımları eksik.');
          }
          return result;
        })
        .toList(growable: false);
    return MealRecipe(
      name: name,
      description: description,
      caution: caution,
      ingredients: List.unmodifiable(ingredients),
      steps: List.unmodifiable(steps),
      prepMinutes: _amount(json['prep_minutes'], 360).round(),
      caloriesKcal: _amount(json['calories_kcal'], 5000).round(),
      proteinG: _amount(json['protein_g'], 500),
      carbsG: _amount(json['carbs_g'], 500),
      fatG: _amount(json['fat_g'], 500),
      fiberG: _amount(json['fiber_g'], 200),
    );
  }
}

String _text(Object? input, int max) {
  if (input is! String || input.trim().length > max) {
    throw const FormatException('Tarif metni geçersiz.');
  }
  return input.trim();
}

double _amount(Object? input, double max) {
  if (input is! num || !input.isFinite || input < 0 || input > max) {
    throw const FormatException('Tarif besin miktarı geçersiz.');
  }
  return input.toDouble();
}
