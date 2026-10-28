import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';

/// 2000 ml is an adjustable-in-future UI reference, NOT an individualized
/// medical hydration prescription. Additional glasses remain recordable.
class WaterDaySummary {
  const WaterDaySummary({
    required this.consumedMl,
    required this.goalMl,
    required this.glassCount,
  });

  static const referenceGoalMl = 2000;
  static const glassSizeMl = 250;

  final int consumedMl;
  final int goalMl;
  final int glassCount;

  double get fraction => goalMl == 0 ? 0 : consumedMl / goalMl;

  static WaterDaySummary fromEntries({
    required String userId,
    required DateTime localDay,
    required List<WaterEntry> entries,
    int goalMl = referenceGoalMl,
  }) {
    if (goalMl <= 0) {
      throw ArgumentError.value(goalMl, 'goalMl');
    }
    var total = 0;
    var count = 0;
    for (final entry in entries) {
      if (entry.userId != userId ||
          entry.isDeleted ||
          !isSameLocalDay(entry.recordedAt, localDay)) {
        continue;
      }
      total += entry.amountMl;
      count++;
    }
    return WaterDaySummary(
      consumedMl: total,
      glassCount: count,
      goalMl: goalMl,
    );
  }
}
