import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/buddy/domain/usecases/buddy_progress.dart';

void main() {
  test('XP thresholds are deterministic and remain within 0..1', () {
    expect(BuddyProgress.levelForXp(0), 1);
    expect(BuddyProgress.levelForXp(99), 1);
    expect(BuddyProgress.levelForXp(100), 2);
    expect(BuddyProgress.levelForXp(399), 2);
    expect(BuddyProgress.levelForXp(400), 3);
    expect(BuddyProgress.levelStartXp(3), 400);
    expect(BuddyProgress.nextLevelXp(3), 900);
    expect(BuddyProgress.levelFraction(100), 0);
    expect(BuddyProgress.levelFraction(250), closeTo(.5, .00001));
    expect(() => BuddyProgress.levelForXp(-1), throwsArgumentError);
  });

  test('mood responds positively but does not shame missing records', () {
    expect(BuddyProgress.moodForDay(meals: 0, waterMl: 0), 'neutral');
    expect(BuddyProgress.moodForDay(meals: 1, waterMl: 0), 'happy');
    expect(BuddyProgress.moodForDay(meals: 0, waterMl: 250), 'happy');
    expect(BuddyProgress.moodForDay(meals: 1, waterMl: 250), 'energetic');
    expect(BuddyProgress.rewardedMealsPerUtcDay, 3);
    expect(BuddyProgress.rewardedWaterEntriesPerUtcDay, 8);
  });
}
