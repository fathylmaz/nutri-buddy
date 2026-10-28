import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/meallogrepository.dart';
import 'package:nutri_buddy/features/meals/presentation/pages/meal_logger_page.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/vision_analysis_provider.dart';

class _FakeMeals implements MealLogRepository {
  final logs = <MealLog>[];
  @override
  Future<MealLog?> getById({
    required String userId,
    required String id,
  }) async => null;
  @override
  Future<List<MealLog>> listForUser(String userId) async => logs;
  @override
  Future<void> markDeleted({
    required String userId,
    required String id,
  }) async {}
  @override
  Future<void> saveLocally(MealLog log) async => logs.add(log);
}

void main() {
  testWidgets('manual meal can be saved offline without vision service', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fake = _FakeMeals();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mealLogRepositoryProvider.overrideWithValue(fake),
          visionAnalysisRepositoryProvider.overrideWithValue(null),
        ],
        child: const MaterialApp(home: MealLoggerPage(userId: 'local-user')),
      ),
    );
    await tester.pump();
    await tester.enterText(find.byKey(const Key('meal-name')), 'Ev yemeği');
    final kcalField = find.widgetWithText(TextFormField, 'Kalori (kcal)');
    await tester.ensureVisible(kcalField);
    await tester.enterText(kcalField, '350');
    await tester.ensureVisible(find.byKey(const Key('save-meal')));
    await tester.tap(find.byKey(const Key('save-meal')));
    await tester.pump();
    expect(fake.logs, hasLength(1));
    expect(fake.logs.single.caloriesKcal, 350);
    expect(fake.logs.single.source, 'manual');
    expect(fake.logs.single.userId, 'local-user');
  });
}
