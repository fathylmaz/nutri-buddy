import 'package:nutri_buddy/features/meals/domain/entities/vision_meal_analysis.dart';

/// Infrastructure boundary: untrusted AI JSON is parsed and validated here.
abstract final class VisionMealAnalysisMapper {
  static VisionMealAnalysis fromJson(Map<String, dynamic> json) {
    final foodsRaw = json['foods'];
    if (foodsRaw is! List || foodsRaw.isEmpty || foodsRaw.length > 25) {
      throw const FormatException('Yemek bileşenleri eksik veya geçersiz.');
    }
    final foods = foodsRaw.map((value) {
      if (value is! Map) {
        throw const FormatException('Bileşen geçersiz.');
      }
      final f = Map<String, dynamic>.from(value);
      return VisionFoodEstimate(
        name: _text(f, 'name'),
        grams: _number(f, 'grams'),
        caloriesKcal: _integer(f, 'calories_kcal'),
        proteinG: _number(f, 'protein_g'),
        carbsG: _number(f, 'carbs_g'),
        fatG: _number(f, 'fat_g'),
      );
    }).toList();
    final result = VisionMealAnalysis(
      name: _text(json, 'name'),
      portionGrams: _number(json, 'portion_grams'),
      caloriesKcal: _integer(json, 'calories_kcal'),
      proteinG: _number(json, 'protein_g'),
      carbsG: _number(json, 'carbs_g'),
      fatG: _number(json, 'fat_g'),
      fiberG: _number(json, 'fiber_g'),
      foods: foods,
      vitaminCMg: _optional(json, 'vitamin_c_mg'),
      vitaminAMcg: _optional(json, 'vitamin_a_mcg'),
      vitaminDMcg: _optional(json, 'vitamin_d_mcg'),
      vitaminB12Mcg: _optional(json, 'vitamin_b12_mcg'),
      caution: _text(json, 'caution'),
    );
    if (result.portionGrams < 1 ||
        result.portionGrams > 10000 ||
        result.caloriesKcal > 20000 ||
        result.proteinG > 2000 ||
        result.carbsG > 2000 ||
        result.fatG > 2000 ||
        result.fiberG > 2000 ||
        foods.any(
          (f) =>
              f.grams > 10000 ||
              f.caloriesKcal > 20000 ||
              f.proteinG > 2000 ||
              f.carbsG > 2000 ||
              f.fatG > 2000,
        )) {
      throw const FormatException('Tahminler beklenen aralığın dışında.');
    }
    return result;
  }

  static Map<String, dynamic> toJson(VisionMealAnalysis meal) => {
    'name': meal.name,
    'portion_grams': meal.portionGrams,
    'calories_kcal': meal.caloriesKcal,
    'protein_g': meal.proteinG,
    'carbs_g': meal.carbsG,
    'fat_g': meal.fatG,
    'fiber_g': meal.fiberG,
    'foods': [
      for (final f in meal.foods)
        {
          'name': f.name,
          'grams': f.grams,
          'calories_kcal': f.caloriesKcal,
          'protein_g': f.proteinG,
          'carbs_g': f.carbsG,
          'fat_g': f.fatG,
        },
    ],
    'vitamin_c_mg': meal.vitaminCMg,
    'vitamin_a_mcg': meal.vitaminAMcg,
    'vitamin_d_mcg': meal.vitaminDMcg,
    'vitamin_b12_mcg': meal.vitaminB12Mcg,
    'caution': meal.caution,
  };

  static String _text(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty || value.length > 500) {
      throw FormatException('Eksik veya boş alan: $key');
    }
    return value.trim();
  }

  static double _number(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! num || !value.toDouble().isFinite || value < 0) {
      throw FormatException('Geçersiz sayı: $key');
    }
    return value.toDouble();
  }

  static int _integer(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! int || value < 0) {
      throw FormatException('Geçersiz tamsayı: $key');
    }
    return value;
  }

  static double? _optional(Map<String, dynamic> json, String key) {
    if (json[key] == null) {
      return null;
    }
    final result = _number(json, key);
    if (result > 1000000) {
      throw FormatException('Vitamin aralık dışı: $key');
    }
    return result;
  }
}
