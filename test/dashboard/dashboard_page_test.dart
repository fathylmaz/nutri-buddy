import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/core/sync/account_cloud_restore_service.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/dashboard/domain/repositories/waterrepository.dart';
import 'package:nutri_buddy/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nutri_buddy/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/meallogrepository.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_sync_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

class _FakeWaterRepository implements WaterRepository {
  final _updates = StreamController<List<WaterEntry>>.broadcast(sync: true);
  final _pending = StreamController<int>.broadcast(sync: true);
  final entries = <WaterEntry>[];

  @override
  Future<List<WaterEntry>> listForUser(String userId) async => entries
      .where((entry) => entry.userId == userId && !entry.isDeleted)
      .toList();

  @override
  Stream<List<WaterEntry>> watchForDay(String userId, DateTime day) async* {
    yield await listForUser(userId);
    yield* _updates.stream;
  }

  @override
  Stream<int> watchPendingCount(String userId) async* {
    yield 0;
    yield* _pending.stream;
  }

  void _notify() {
    _updates.add(List<WaterEntry>.from(entries));
    _pending.add(entries.where((entry) => !entry.isDeleted).length);
  }

  @override
  Future<void> saveLocally(WaterEntry entry) async {
    entries.add(entry);
    _notify();
  }

  @override
  Future<bool> undoLastForDay(String userId, DateTime localDay) async {
    final active = entries.where(
      (entry) => entry.userId == userId && !entry.isDeleted,
    );
    if (active.isEmpty) {
      return false;
    }
    final latest = active.last;
    entries[entries.indexOf(latest)] = latest.copyWith(isDeleted: true);
    _notify();
    return true;
  }

  Future<void> dispose() async {
    await _updates.close();
    await _pending.close();
  }
}

class _EmptyMeals implements MealLogRepository {
  @override
  Future<MealLog?> getById({
    required String userId,
    required String id,
  }) async => null;
  @override
  Future<List<MealLog>> listForUser(String userId) async => [];
  @override
  Future<void> markDeleted({
    required String userId,
    required String id,
  }) async {}
  @override
  Future<void> saveLocally(MealLog log) async {}
}

void main() {
  testWidgets(
    'dashboard shows zero meals and persists +250 / undo through the repository',
    (tester) async {
      final repo = _FakeWaterRepository();
      addTearDown(repo.dispose);
      final profile = UserProfile(
        id: 'test-account',
        displayName: 'Deneme',
        birthDate: DateTime(1990, 1, 1),
        sexForCalculation: 'male',
        heightCm: 177,
        weightKg: 79,
        targetWeightKg: 75,
        activityLevel: 'light',
        goal: 'maintain',
        updatedAt: DateTime.utc(2026, 10, 23),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountCloudRestoreProvider.overrideWith((ref) => null),
            waterRepositoryProvider.overrideWith((ref) => repo),
            waterCloudSyncProvider.overrideWith((ref) => null),
            mealLogRepositoryProvider.overrideWithValue(_EmptyMeals()),
            pendingMealCountProvider('test-account')
                .overrideWith((ref) => Stream.value(0)),
            mealCloudSyncProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: DashboardPage(userId: 'test-account', profile: profile),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Bugün henüz öğün kaydı yok.'), findsOneWidget);

      // The water card is below the nutrition card and may be outside the
      // small default widget-test viewport. Scroll before inspecting it.
      final addWater = find.byKey(const Key('add-water'));
      await tester.scrollUntilVisible(
        addWater,
        250.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(addWater);
      await tester.pumpAndSettle();
      expect(find.text('0 ml'), findsOneWidget);
      await tester.tap(find.byKey(const Key('add-water')));
      await tester.pumpAndSettle();
      expect(find.text('250 ml'), findsOneWidget);
      expect(repo.entries.single.amountMl, 250);
      await tester.ensureVisible(find.byKey(const Key('undo-water')));
      await tester.tap(find.byKey(const Key('undo-water')));
      await tester.pumpAndSettle();
      expect(find.text('0 ml'), findsOneWidget);
      expect(repo.entries.single.isDeleted, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
