/// The server uses the same thresholds. Pure Dart so it can be unit-tested.
abstract final class BuddyProgress {
  static const mealXp = 20;
  static const waterXp = 5;
  static const mealGold = 4;
  static const waterGold = 1;
  static const rewardedMealsPerUtcDay = 3;
  static const rewardedWaterEntriesPerUtcDay = 8;

  static int levelForXp(int xp) {
    if (xp < 0) throw ArgumentError.value(xp, 'xp');
    var level = 1;
    while (xp >= 100 * level * level) {
      level++;
    }
    return level;
  }

  static int levelStartXp(int level) {
    if (level < 1) throw ArgumentError.value(level, 'level');
    return 100 * (level - 1) * (level - 1);
  }

  static int nextLevelXp(int level) {
    if (level < 1) throw ArgumentError.value(level, 'level');
    return 100 * level * level;
  }

  static double levelFraction(int xp) {
    final level = levelForXp(xp);
    final start = levelStartXp(level);
    return ((xp - start) / (nextLevelXp(level) - start)).clamp(0.0, 1.0);
  }

  /// No negative emotions or penalties for missing nutrition records.
  static String moodForDay({required int meals, required int waterMl}) {
    if (meals > 0 && waterMl > 0) return 'energetic';
    if (meals > 0 || waterMl > 0) return 'happy';
    return 'neutral';
  }
}
