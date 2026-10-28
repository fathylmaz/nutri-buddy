import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';
import 'package:nutri_buddy/features/analytics/domain/usecases/analytics_snapshot.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

const targets = NutritionTargets(
  bmrKcal: 1500,
  tdeeKcal: 2200,
  dailyCalories: 2000,
  proteinG: 100,
  carbsG: 230,
  fatG: 60,
);

MealLog meal(
  String id,
  String uid,
  DateTime d,
  int kcal, {
  double protein = 20,
  bool deleted = false,
}) => MealLog(
  id: id,
  userId: uid,
  loggedAt: d,
  name: 'Test',
  caloriesKcal: kcal,
  proteinG: protein,
  isDeleted: deleted,
  updatedAt: d,
);
WaterEntry water(
  String id,
  String uid,
  DateTime d,
  int ml, {
  bool deleted = false,
}) => WaterEntry(
  id: id,
  userId: uid,
  amountMl: ml,
  recordedAt: d,
  updatedAt: d,
  isDeleted: deleted,
);
WeightEntry weight(
  String id,
  String uid,
  DateTime d,
  double kg, {
  bool deleted = false,
}) => WeightEntry(
  id: id,
  userId: uid,
  weightKg: kg,
  recordedAt: d,
  updatedAt: d,
  isDeleted: deleted,
);

void main() {
  test('missing calendar days are NOT counted as zero-energy days', () {
    final summary = AnalyticsSnapshot.build(
      userId: 'a',
      today: DateTime(2026, 10, 24),
      periodDays: 7,
      targets: targets,
      meals: [
        meal('1', 'a', DateTime(2026, 10, 24, 11), 1800),
        meal('2', 'a', DateTime(2026, 10, 23, 17), 2200),
        meal('3', 'b', DateTime(2026, 10, 22), 9999),
        meal('4', 'a', DateTime(2026, 10, 21), 9999, deleted: true),
        meal('5', 'a', DateTime(2026, 10, 15), 9999),
      ],
      waters: [water('w', 'a', DateTime(2026, 10, 24), 250)],
      weights: [],
    );
    expect(summary.days, hasLength(7));
    expect(summary.loggedMealDays, 2);
    expect(summary.averageCaloriesLoggedDays, 2000);
    expect(summary.calorieNearTargetDays, 2); // ±10% inclusive
    expect(summary.days.where((d) => !d.hasMeals), hasLength(5));
    expect(summary.loggedWaterDays, 1);
    expect(summary.averageWaterLoggedDays, 250);
    expect(summary.averageProteinLoggedDays, 20);
  });

  test(
    'empty period reports missing observations rather than zero averages',
    () {
      final summary = AnalyticsSnapshot.build(
        userId: 'a',
        today: DateTime(2026, 10, 24),
        periodDays: 30,
        targets: targets,
        meals: [],
        waters: [],
        weights: [],
      );
      expect(summary.averageCaloriesLoggedDays, isNull);
      expect(summary.averageWaterLoggedDays, isNull);
      expect(summary.weightChangeKg, isNull);
      expect(summary.loggedMealDays, 0);
    },
  );

  test(
    'weight trend is sorted, owner-scoped and ignores deleted/future data',
    () {
      final summary = AnalyticsSnapshot.build(
        userId: 'a',
        today: DateTime(2026, 10, 24),
        periodDays: 7,
        targets: targets,
        meals: [],
        waters: [],
        weights: [
          weight('l', 'a', DateTime(2026, 10, 24, 10), 70),
          weight('other', 'b', DateTime(2026, 10, 24), 1),
          weight('f', 'a', DateTime(2026, 10, 19), 72),
          weight('deleted', 'a', DateTime(2026, 10, 20), 100, deleted: true),
          weight('future', 'a', DateTime(2026, 11, 1), 10),
        ],
      );
      expect(summary.weightEntries.map((e) => e.id), ['f', 'l']);
      expect(summary.lastWeightKg, 70);
      expect(summary.weightChangeKg, -2);
    },
  );

  test('calendar range correctly crosses a month boundary', () {
    final summary = AnalyticsSnapshot.build(
      userId: 'a',
      today: DateTime(2026, 11, 2),
      periodDays: 7,
      targets: targets,
      meals: [
        meal('1', 'a', DateTime(2026, 10, 31, 19), 500),
        meal('2', 'a', DateTime(2026, 11, 2, 8), 750),
      ],
      waters: [],
      weights: [],
    );
    expect(summary.days.first.day, DateTime(2026, 10, 27));
    expect(summary.days.last.day, DateTime(2026, 11, 2));
    expect(summary.loggedMealDays, 2);
  });

  test('invalid period is rejected', () {
    expect(
      () => AnalyticsSnapshot.build(
        userId: 'a',
        today: DateTime.now(),
        periodDays: 0,
        targets: targets,
        meals: [],
        waters: [],
        weights: [],
      ),
      throwsArgumentError,
    );
  });
}
