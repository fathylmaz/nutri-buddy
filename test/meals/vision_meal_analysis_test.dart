import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meals/data/mappers/vision_meal_analysis_mapper.dart';

Map<String, dynamic> validResponse() => {
  'name': 'Tavuklu salata',
  'portion_grams': 310.0,
  'calories_kcal': 420,
  'protein_g': 36.0,
  'carbs_g': 25.0,
  'fat_g': 18.0,
  'fiber_g': 7.0,
  'foods': [
    {
      'name': 'Izgara tavuk',
      'grams': 120.0,
      'calories_kcal': 200,
      'protein_g': 32.0,
      'carbs_g': 0.0,
      'fat_g': 8.0,
    },
  ],
  'vitamin_c_mg': null,
  'vitamin_a_mcg': 60.0,
  'vitamin_d_mcg': null,
  'vitamin_b12_mcg': 0.4,
  'caution': 'Sos ve pişirme yağı fotoğraftan kesin ölçülemez.',
};

void main() {
  test('vision JSON parses without turning unknown vitamins into zero', () {
    final analysis = VisionMealAnalysisMapper.fromJson(validResponse());
    expect(analysis.name, 'Tavuklu salata');
    expect(analysis.vitaminCMg, isNull);
    expect(analysis.vitaminAMcg, 60);
    expect(analysis.foods.single.grams, 120);
    expect(analysis.scaled(2).foods.single.grams, 240);
    expect(analysis.scaled(2).vitaminAMcg, 120);
    expect(
      VisionMealAnalysisMapper.fromJson(
        VisionMealAnalysisMapper.toJson(analysis),
      ).caloriesKcal,
      420,
    );
  });

  test('missing foods and negative macro values are rejected', () {
    final missing = validResponse()..['foods'] = [];
    expect(
      () => VisionMealAnalysisMapper.fromJson(missing),
      throwsFormatException,
    );
    final negative = validResponse()..['protein_g'] = -1.0;
    expect(
      () => VisionMealAnalysisMapper.fromJson(negative),
      throwsFormatException,
    );
  });

  test('rejects unbounded estimates and invalid vitamin type', () {
    final oversize = validResponse()..['portion_grams'] = 10001.0;
    expect(
      () => VisionMealAnalysisMapper.fromJson(oversize),
      throwsFormatException,
    );
    final invalid = validResponse()..['vitamin_c_mg'] = 'unknown';
    expect(
      () => VisionMealAnalysisMapper.fromJson(invalid),
      throwsFormatException,
    );
  });
}
