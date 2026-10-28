import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meals/data/mappers/meal_log_mapper.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/domain/entities/vision_meal_analysis.dart';

void main() {
  test(
    'persists a vision estimate as optional JSON without losing base macros',
    () {
      final original = MealLog(
        id: 'sample',
        userId: 'user-1',
        name: 'Sandviç',
        loggedAt: DateTime.utc(2026, 10, 23, 12),
        updatedAt: DateTime.utc(2026, 10, 23, 12),
        caloriesKcal: 300,
        proteinG: 20,
        source: 'vision',
        visionAnalysis: VisionMealAnalysis(
          name: 'Sandviç',
          portionGrams: 200,
          caloriesKcal: 310,
          proteinG: 20,
          carbsG: 30,
          fatG: 10,
          fiberG: 4,
          vitaminCMg: null,
          vitaminAMcg: null,
          vitaminDMcg: null,
          vitaminB12Mcg: 0.5,
          caution: 'Tahmini',
          foods: [
            const VisionFoodEstimate(
              name: 'Ekmek',
              grams: 100,
              caloriesKcal: 200,
              proteinG: 6,
              carbsG: 40,
              fatG: 2,
            ),
          ],
        ),
      );
      final entity = MealLogMapper.toDomain(MealLogMapper.toRecord(original));
      expect(entity.caloriesKcal, 300);
      expect(entity.visionAnalysis?.caloriesKcal, 310);
      expect(entity.visionAnalysis?.vitaminCMg, isNull);
      expect(entity.visionAnalysis?.foods.single.name, 'Ekmek');
    },
  );
}
