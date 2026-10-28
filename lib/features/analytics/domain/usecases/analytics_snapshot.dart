import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

/// Local calendar day: omit the time component but preserve local calendar
/// boundaries, including DST changes. Subtract calendar days via DateTime
/// constructor, NOT Duration(days: 1).
DateTime analyticsLocalDay(DateTime instant) {
  final local = instant.toLocal();
  return DateTime(local.year, local.month, local.day);
}

class AnalyticsDay {
  const AnalyticsDay({
    required this.day,
    required this.mealCount,
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterMl,
    required this.waterCount,
  });
  final DateTime day;
  final int mealCount;
  final int caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int waterMl;
  final int waterCount;
  bool get hasMeals => mealCount > 0;
  bool get hasWater => waterCount > 0;
}

/// Descriptive statistics for *locally available* records, not medical advice.
/// Missing days are unobserved; they are never treated as zero consumption.
class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.days,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
    required this.waterReferenceMl,
    required this.loggedMealDays,
    required this.loggedWaterDays,
    required this.averageCaloriesLoggedDays,
    required this.averageWaterLoggedDays,
    required this.averageProteinLoggedDays,
    required this.averageCarbsLoggedDays,
    required this.averageFatLoggedDays,
    required this.calorieNearTargetDays,
    required this.weightEntries,
  });

  final List<AnalyticsDay> days;
  final int calorieTarget;
  final int proteinTarget;
  final int carbsTarget;
  final int fatTarget;
  final int waterReferenceMl;
  final int loggedMealDays;
  final int loggedWaterDays;
  final double? averageCaloriesLoggedDays;
  final double? averageWaterLoggedDays;
  final double? averageProteinLoggedDays;
  final double? averageCarbsLoggedDays;
  final double? averageFatLoggedDays;
  final int calorieNearTargetDays;
  final List<WeightEntry> weightEntries;

  double? get weightChangeKg => weightEntries.length < 2
      ? null
      : weightEntries.last.weightKg - weightEntries.first.weightKg;
  double? get lastWeightKg =>
      weightEntries.isEmpty ? null : weightEntries.last.weightKg;

  static AnalyticsSnapshot build({
    required String userId,
    required DateTime today,
    required int periodDays,
    required NutritionTargets targets,
    required List<MealLog> meals,
    required List<WaterEntry> waters,
    required List<WeightEntry> weights,
    int waterReferenceMl = 2000,
  }) {
    if (userId.isEmpty ||
        periodDays < 1 ||
        periodDays > 365 ||
        waterReferenceMl <= 0) {
      throw ArgumentError('Invalid analytics query');
    }
    final localToday = analyticsLocalDay(today);
    final start = DateTime(
      localToday.year,
      localToday.month,
      localToday.day - periodDays + 1,
    );
    final buckets = <DateTime, _Accumulator>{};
    for (var i = 0; i < periodDays; i++) {
      final date = DateTime(start.year, start.month, start.day + i);
      buckets[date] = _Accumulator();
    }

    for (final meal in meals) {
      if (meal.userId != userId ||
          meal.isDeleted ||
          meal.caloriesKcal < 0 ||
          meal.proteinG < 0 ||
          meal.carbsG < 0 ||
          meal.fatG < 0 ||
          !meal.proteinG.isFinite ||
          !meal.carbsG.isFinite ||
          !meal.fatG.isFinite) {
        continue;
      }
      final bucket = buckets[analyticsLocalDay(meal.loggedAt)];
      if (bucket == null) continue;
      bucket.mealCount++;
      bucket.calories += meal.caloriesKcal;
      bucket.protein += meal.proteinG;
      bucket.carbs += meal.carbsG;
      bucket.fat += meal.fatG;
    }
    for (final water in waters) {
      if (water.userId != userId || water.isDeleted || water.amountMl <= 0) {
        continue;
      }
      final bucket = buckets[analyticsLocalDay(water.recordedAt)];
      if (bucket == null) continue;
      bucket.waterCount++;
      bucket.water += water.amountMl;
    }
    final dates = buckets.entries
        .map((e) {
          final b = e.value;
          return AnalyticsDay(
            day: e.key,
            mealCount: b.mealCount,
            caloriesKcal: b.calories,
            proteinG: b.protein,
            carbsG: b.carbs,
            fatG: b.fat,
            waterMl: b.water,
            waterCount: b.waterCount,
          );
        })
        .toList(growable: false);
    final mealDays = dates.where((d) => d.hasMeals).toList();
    final waterDays = dates.where((d) => d.hasWater).toList();
    final weightRows =
        weights
            .where(
              (w) =>
                  w.userId == userId &&
                  !w.isDeleted &&
                  w.weightKg.isFinite &&
                  w.weightKg >= 10 &&
                  w.weightKg <= 500 &&
                  !analyticsLocalDay(w.recordedAt).isBefore(start) &&
                  !analyticsLocalDay(w.recordedAt).isAfter(localToday),
            )
            .toList()
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    double? average<T>(List<T> data, double Function(T) extract) => data.isEmpty
        ? null
        : data.fold<double>(0, (sum, item) => sum + extract(item)) /
              data.length;
    final limit = targets.dailyCalories * .10;
    return AnalyticsSnapshot(
      days: dates,
      calorieTarget: targets.dailyCalories,
      proteinTarget: targets.proteinG,
      carbsTarget: targets.carbsG,
      fatTarget: targets.fatG,
      waterReferenceMl: waterReferenceMl,
      loggedMealDays: mealDays.length,
      loggedWaterDays: waterDays.length,
      averageCaloriesLoggedDays: average(
        mealDays,
        (d) => d.caloriesKcal.toDouble(),
      ),
      averageWaterLoggedDays: average(waterDays, (d) => d.waterMl.toDouble()),
      averageProteinLoggedDays: average(mealDays, (d) => d.proteinG),
      averageCarbsLoggedDays: average(mealDays, (d) => d.carbsG),
      averageFatLoggedDays: average(mealDays, (d) => d.fatG),
      calorieNearTargetDays: mealDays
          .where((d) => (d.caloriesKcal - targets.dailyCalories).abs() <= limit)
          .length,
      weightEntries: List.unmodifiable(weightRows),
    );
  }
}

class _Accumulator {
  int mealCount = 0;
  int calories = 0;
  double protein = 0;
  double carbs = 0;
  double fat = 0;
  int waterCount = 0;
  int water = 0;
}
