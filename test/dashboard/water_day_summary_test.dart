import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/water_day_summary.dart';

void main() {
  test('multiple glasses are accumulated without a goal cap', () {
    final day = DateTime(2026, 10, 23);
    WaterEntry entry({
      required String id,
      String owner = 'one',
      bool deleted = false,
      DateTime? date,
    }) => WaterEntry(
      id: id,
      userId: owner,
      amountMl: WaterDaySummary.glassSizeMl,
      recordedAt: date ?? day.add(const Duration(hours: 14)),
      updatedAt: day,
      isDeleted: deleted,
    );

    final result = WaterDaySummary.fromEntries(
      userId: 'one',
      localDay: day,
      entries: [
        for (var i = 0; i < 10; i++) entry(id: '$i'),
        entry(id: 'other-user', owner: 'two'),
        entry(id: 'tombstone', deleted: true),
        entry(id: 'yesterday', date: day.subtract(const Duration(minutes: 1))),
      ],
    );

    expect(result.consumedMl, 2500);
    expect(result.glassCount, 10);
    expect(result.fraction, 1.25);
  });

  test('day boundaries are local and invalid goals are rejected', () {
    expect(
      () => WaterDaySummary.fromEntries(
        userId: 'one',
        localDay: DateTime(2026),
        entries: [],
        goalMl: 0,
      ),
      throwsArgumentError,
    );
  });
}
