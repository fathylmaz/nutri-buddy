import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meals/data/mappers/meal_log_mapper.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';

void main() {
  test('ai_recipe snapshot survives Isar record/domain conversion', () {
    final now = DateTime.utc(2026, 10, 23, 11);
    final log = MealLog(
      id: 'recipe-1',
      userId: 'owner-1',
      name: 'Sebzeli çorba',
      loggedAt: now,
      updatedAt: now,
      source: 'ai_recipe',
      caloriesKcal: 210,
      recipeDetailsJson: jsonEncode({
        'name': 'Sebzeli çorba',
        'steps': ['Haşla', 'Karıştır'],
      }),
    );
    final record = MealLogMapper.toRecord(log);
    final restored = MealLogMapper.toDomain(record);
    expect(restored.source, 'ai_recipe');
    expect(restored.recipeDetailsJson, log.recipeDetailsJson);
    expect(restored.userId, 'owner-1');
  });
}
