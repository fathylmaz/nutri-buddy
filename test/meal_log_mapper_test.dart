import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meals/data/mappers/meal_log_mapper.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';

void main() {
  test('meal log maps to Isar record and round-trips', () {
    final date = DateTime.utc(2026, 10, 22, 9);
    final entry = MealLog(
      id: '29c3ad85-b7f0-4cc0-aa75-3e9d18d20011',
      userId: 'test-user',
      loggedAt: date,
      name: 'Yumurta ve lor',
      caloriesKcal: 400,
      proteinG: 30,
      carbsG: 35,
      fatG: 12,
      updatedAt: date,
    );
    final record = MealLogMapper.toRecord(entry);
    expect(record.pendingSync, isTrue);
    expect(record.recordId, entry.id);
    final result = MealLogMapper.toDomain(record);
    expect(result, entry);
  });
}
