import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';

void main() {
  test('sums only active meals owned by this user on the local day', () {
    final day = DateTime(2026, 10, 23);
    MealLog meal({
      required String id,
      required String owner,
      required DateTime when,
      bool deleted = false,
    }) => MealLog(
      id: id,
      userId: owner,
      loggedAt: when,
      updatedAt: when,
      name: 'Test meal',
      caloriesKcal: 400,
      proteinG: 30,
      carbsG: 35,
      fatG: 15,
      isDeleted: deleted,
    );

    final result = DailyNutritionSummary.fromLogs(
      userId: 'user-1',
      localDay: day,
      logs: [
        meal(id: 'a', owner: 'user-1', when: DateTime(2026, 10, 23, 11)),
        meal(id: 'b', owner: 'user-1', when: DateTime(2026, 10, 23, 19)),
        meal(id: 'c', owner: 'user-2', when: DateTime(2026, 10, 23, 13)),
        meal(id: 'd', owner: 'user-1', when: DateTime(2026, 10, 22, 23)),
        meal(
          id: 'e',
          owner: 'user-1',
          when: DateTime(2026, 10, 23, 12),
          deleted: true,
        ),
      ],
    );

    expect(result.mealCount, 2);
    expect(result.caloriesKcal, 800);
    expect(result.proteinG, 60);
    expect(result.carbsG, 70);
    expect(result.fatG, 30);
  });
}
