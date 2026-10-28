import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';
import 'package:nutri_buddy/features/buddy/domain/entities/buddy_pet.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';

void main() {
  final now = DateTime.utc(2026, 10, 22);

  test('pet state is immutable and copyable', () {
    final pet = BuddyPet(id: 'pet', userId: 'u', updatedAt: now);
    expect(pet.gold, 0);
    expect(pet.copyWith(gold: 12).gold, 12);
    expect(pet.gold, 0);
  });

  test('water and weight records remain independent', () {
    final water = WaterEntry(
      id: 'water',
      userId: 'u',
      amountMl: 250,
      recordedAt: now,
      updatedAt: now,
    );
    final weight = WeightEntry(
      id: 'weight',
      userId: 'u',
      weightKg: 74.5,
      recordedAt: now,
      updatedAt: now,
    );
    expect(water.amountMl, 250);
    expect(weight.weightKg, 74.5);
  });
}
