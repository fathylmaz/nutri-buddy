import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';

/// A calendar day in the device's local time zone. Do not compare UTC dates:
/// an evening meal or glass of water may belong to tomorrow in UTC.
bool isSameLocalDay(DateTime instant, DateTime localDay) {
  final value = instant.toLocal();
  return value.year == localDay.year &&
      value.month == localDay.month &&
      value.day == localDay.day;
}

class DailyNutritionSummary {
  const DailyNutritionSummary({
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.mealCount,
  });

  final int caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int mealCount;

  static DailyNutritionSummary fromLogs({
    required String userId,
    required DateTime localDay,
    required List<MealLog> logs,
  }) {
    var calories = 0;
    var protein = 0.0;
    var carbs = 0.0;
    var fat = 0.0;
    var count = 0;
    for (final log in logs) {
      if (log.userId != userId ||
          log.isDeleted ||
          !isSameLocalDay(log.loggedAt, localDay)) {
        continue;
      }
      calories += log.caloriesKcal;
      protein += log.proteinG;
      carbs += log.carbsG;
      fat += log.fatG;
      count++;
    }
    return DailyNutritionSummary(
      caloriesKcal: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      mealCount: count,
    );
  }
}
