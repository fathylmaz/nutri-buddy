/// Pure immutable domain objects; no JSON, network or database dependencies.
/// Nutrition quantities are unverified estimates, not medical measurements.
final class VisionFoodEstimate {
  const VisionFoodEstimate({
    required this.name,
    required this.grams,
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String name;
  final double grams;
  final int caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;

  VisionFoodEstimate scaled(double factor) => VisionFoodEstimate(
    name: name,
    grams: grams * factor,
    caloriesKcal: (caloriesKcal * factor).round(),
    proteinG: proteinG * factor,
    carbsG: carbsG * factor,
    fatG: fatG * factor,
  );
}

final class VisionMealAnalysis {
  VisionMealAnalysis({
    required this.name,
    required this.portionGrams,
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required List<VisionFoodEstimate> foods,
    required this.vitaminCMg,
    required this.vitaminAMcg,
    required this.vitaminDMcg,
    required this.vitaminB12Mcg,
    required this.caution,
  }) : foods = List.unmodifiable(foods);

  final String name;
  final double portionGrams;
  final int caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final List<VisionFoodEstimate> foods;
  final double? vitaminCMg;
  final double? vitaminAMcg;
  final double? vitaminDMcg;
  final double? vitaminB12Mcg;
  final String caution;

  /// All displayed portions and vitamins scale with the user's correction.
  VisionMealAnalysis scaled(double factor) {
    if (!factor.isFinite || factor <= 0 || factor > 3) {
      throw ArgumentError.value(factor, 'factor');
    }
    return VisionMealAnalysis(
      name: name,
      portionGrams: portionGrams * factor,
      caloriesKcal: (caloriesKcal * factor).round(),
      proteinG: proteinG * factor,
      carbsG: carbsG * factor,
      fatG: fatG * factor,
      fiberG: fiberG * factor,
      foods: foods.map((f) => f.scaled(factor)).toList(),
      vitaminCMg: vitaminCMg == null ? null : vitaminCMg! * factor,
      vitaminAMcg: vitaminAMcg == null ? null : vitaminAMcg! * factor,
      vitaminDMcg: vitaminDMcg == null ? null : vitaminDMcg! * factor,
      vitaminB12Mcg: vitaminB12Mcg == null ? null : vitaminB12Mcg! * factor,
      caution: caution,
    );
  }
}
