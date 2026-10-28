import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

void main() {
  final day = DateTime(2026, 10, 22);
  UserProfile sample({String goal = 'maintain', DateTime? birthDate}) =>
      UserProfile(
        id: 'test-id',
        sexForCalculation: 'male',
        birthDate: birthDate ?? DateTime(1996, 10, 22),
        heightCm: 180,
        weightKg: 80,
        targetWeightKg: 78,
        activityLevel: 'moderate',
        goal: goal,
        updatedAt: day,
      );

  test('Mifflin-St Jeor male BMR, TDEE and macros', () {
    final v = NutritionCalculator.calculate(sample(), today: day);
    expect(v.bmrKcal, 1780);
    expect(v.tdeeKcal, 2759);
    expect(v.dailyCalories, 2759);
    expect(v.proteinG, 112);
    expect(
      v.proteinG * 4 + v.carbsG * 4 + v.fatG * 9,
      closeTo(v.dailyCalories, 6),
    );
  });

  test('weight loss is a capped moderate deficit, not aggressive', () {
    final maintain = NutritionCalculator.calculate(sample(), today: day);
    final lose = NutritionCalculator.calculate(
      sample(goal: 'lose'),
      today: day,
    );
    expect(lose.dailyCalories, lessThan(maintain.dailyCalories));
    expect(lose.dailyCalories, greaterThanOrEqualTo(1500));
  });

  test('birthday boundary changes age', () {
    expect(NutritionCalculator.ageOn(DateTime(2000, 10, 23), day), 25);
    expect(NutritionCalculator.ageOn(DateTime(2000, 10, 22), day), 26);
  });

  test('underage profiles are rejected', () {
    expect(
      () => NutritionCalculator.calculate(
        sample(birthDate: DateTime(2010, 1, 1)),
        today: day,
      ),
      throwsFormatException,
    );
  });
}
