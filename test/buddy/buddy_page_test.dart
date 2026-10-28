import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/buddy/domain/entities/buddy_pet.dart';
import 'package:nutri_buddy/features/buddy/presentation/pages/buddy_page.dart';
import 'package:nutri_buddy/features/buddy/presentation/providers/buddy_providers.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/water_day_summary.dart';
import 'package:nutri_buddy/features/dashboard/presentation/providers/dashboard_providers.dart';

void main() {
  testWidgets('shows cached XP while cloud is unavailable', (tester) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final pet = BuddyPet(
      id: 'pet1',
      userId: 'user1',
      xp: 145,
      level: 2,
      gold: 18,
      streakDays: 2,
      updatedAt: now,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          buddyCloudServiceProvider.overrideWith((ref) => null),
          buddyPetProvider('user1').overrideWith((ref) => Stream.value(pet)),
          waterDayProvider('user1', day).overrideWith(
            (ref) => Stream.value(
              const WaterDaySummary(
                consumedMl: 250,
                goalMl: 2000,
                glassCount: 1,
              ),
            ),
          ),
          dailyNutritionProvider('user1', day).overrideWith(
            (ref) async => const DailyNutritionSummary(
              caloriesKcal: 310,
              proteinG: 20,
              carbsG: 35,
              fatG: 10,
              mealCount: 1,
            ),
          ),
        ],
        child: const MaterialApp(home: BuddyPage(userId: 'user1')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Seviye 2'), findsOneWidget);
    expect(find.textContaining('145 XP'), findsOneWidget);
    expect(find.byKey(const Key('buddy-animated-fallback')), findsOneWidget);

    // ListView lazily builds off-screen children. Scroll until the shop
    // button is built and visible before asserting that it exists.
    await tester.scrollUntilVisible(
      find.byKey(const Key('buddy-shop')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('buddy-shop')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
