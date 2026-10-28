import 'dart:math' as math;

import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

class NutritionTargets {
  const NutritionTargets({
    required this.bmrKcal,
    required this.tdeeKcal,
    required this.dailyCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final int bmrKcal;
  final int tdeeKcal;
  final int dailyCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
}

/// General adult estimates, NOT medical prescriptions. Never enable an
/// automatically calculated aggressive deficit in the presence of health risks.
abstract final class NutritionCalculator {
  static int ageOn(DateTime birthday, DateTime today) {
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  static NutritionTargets calculate(UserProfile profile, {DateTime? today}) {
    final birth = profile.birthDate;
    final sex = profile.sexForCalculation;
    final height = profile.heightCm;
    final weight = profile.weightKg;
    final activity = profile.activityLevel;
    final goal = profile.goal;
    if (birth == null ||
        sex == null ||
        height == null ||
        weight == null ||
        activity == null ||
        goal == null) {
      throw const FormatException('Hesaplama için tüm temel bilgiler gerekli.');
    }
    final age = ageOn(birth, today ?? DateTime.now());
    if (age < 18 ||
        age > 110 ||
        height < 100 ||
        height > 250 ||
        weight < 25 ||
        weight > 350 ||
        !weight.isFinite ||
        !height.isFinite) {
      throw const FormatException(
        'Hesaplama yalnızca yetişkinler ve geçerli ölçümler içindir.',
      );
    }
    const activities = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };
    if (!activities.containsKey(activity) ||
        !['male', 'female'].contains(sex) ||
        !['lose', 'gain', 'recomposition', 'maintain'].contains(goal)) {
      throw const FormatException(
        'Aktivite, hedef veya hesaplama katsayısı geçersiz.',
      );
    }
    // Mifflin-St Jeor equation (sex-based coefficient is a limitation of model).
    final bmr =
        10 * weight + 6.25 * height - 5 * age + (sex == 'male' ? 5 : -161);
    final tdee = bmr * activities[activity]!;
    final adjusted = switch (goal) {
      'lose' => tdee * 0.85,
      'gain' => tdee * 1.10,
      _ => tdee,
    };
    // Conservative numerical floor; not a blanket recommendation.
    final floor = sex == 'male' ? 1500.0 : 1200.0;
    final calories = math.max(floor, adjusted).round();
    final protein = (weight * (goal == 'maintain' ? 1.4 : 1.6)).round();
    final fat = (calories * .25 / 9).round();
    final carbs = ((calories - 4 * protein - 9 * fat) / 4).round();
    if (carbs < 0) {
      throw const FormatException(
        'Bu ölçümler için otomatik makro hedefi güvenilir değil.',
      );
    }
    return NutritionTargets(
      bmrKcal: bmr.round(),
      tdeeKcal: tdee.round(),
      dailyCalories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
    );
  }
}
