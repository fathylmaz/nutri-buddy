import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';
import 'package:nutri_buddy/features/meal_builder/domain/repositories/meal_builder_repository.dart';
import 'package:nutri_buddy/features/meal_builder/presentation/pages/meal_builder_page.dart';
import 'package:nutri_buddy/features/meal_builder/presentation/providers/meal_builder_providers.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/meallogrepository.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

class _Recipes implements MealBuilderRepository {
  MealBuilderRequest? lastRequest;

  @override
  Future<List<MealRecipe>> generate(MealBuilderRequest request) async {
    lastRequest = request;
    return List.generate(
      request.count,
      (i) => MealRecipe.fromJson({
        'name': 'Sebzeli pilav $i',
        'description': 'Pratik sebzeli tabak',
        'ingredients': [
          {'name': 'Pirinç', 'quantity': '80 g', 'grams': 80},
          {'name': 'Biber', 'quantity': '1 adet', 'grams': 60},
        ],
        'steps': ['Pirinci yıka.', 'Malzemeleri birlikte pişir.'],
        'prep_minutes': 20,
        'calories_kcal': 350,
        'protein_g': 9,
        'carbs_g': 65,
        'fat_g': 6,
        'fiber_g': 4,
        'caution': 'İçerikleri ve alerjenleri doğrula.',
      }),
    );
  }
}

class _Meals implements MealLogRepository {
  final records = <MealLog>[];
  @override
  Future<MealLog?> getById({
    required String userId,
    required String id,
  }) async =>
      records.where((e) => e.userId == userId && e.id == id).firstOrNull;
  @override
  Future<List<MealLog>> listForUser(String userId) async =>
      records.where((e) => e.userId == userId && !e.isDeleted).toList();
  @override
  Future<void> saveLocally(MealLog log) async => records.add(log);
  @override
  Future<void> markDeleted({
    required String userId,
    required String id,
  }) async {}
}

/// Locate lazily built widgets by scrolling the page's *outer* ListView.
/// A ListView may not build widgets below the test viewport until scrolled,
/// so calling tester.getRect(target) before scrolling throws for missing keys.
/// The explicit Scrollable prevents ambiguity with nested scroll views.
Future<void> _scrollTo(WidgetTester tester, Key key) async {
  final target = find.byKey(key);
  final outerScrollable = find
      .descendant(
        of: find.byType(ListView).first,
        matching: find.byType(Scrollable),
      )
      .first;

  await tester.scrollUntilVisible(
    target,
    250.0,
    scrollable: outerScrollable,
    maxScrolls: 30,
  );
  await tester.pumpAndSettle();
  expect(target, findsOneWidget);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'generates after consent and saves editable recipe with details',
    (tester) async {
      final api = _Recipes();
      final meals = _Meals();
      final profile = UserProfile(
        id: 'tester',
        birthDate: DateTime(1994, 3, 1),
        sexForCalculation: 'female',
        heightCm: 165,
        weightKg: 65,
        activityLevel: 'moderate',
        goal: 'maintain',
        allergies: const ['fıstık'],
        updatedAt: DateTime.utc(2026, 10, 23),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mealBuilderRepositoryProvider.overrideWithValue(api),
            mealLogRepositoryProvider.overrideWithValue(meals),
          ],
          child: MaterialApp(
            home: MealBuilderPage(userId: 'tester', profile: profile),
          ),
        ),
      );
      await tester.pumpAndSettle();
      const consentKey = Key('builder-consent');
      await _scrollTo(tester, consentKey);
      final consent = find.byKey(consentKey);
      await tester.tap(consent);
      await tester.pumpAndSettle();
      const generateKey = Key('generate-recipes');
      await _scrollTo(tester, generateKey);
      final generate = find.byKey(generateKey);
      await tester.tap(generate);
      await tester.pumpAndSettle();
      expect(api.lastRequest?.exclusions, ['fıstık']);
      expect(api.lastRequest?.count, 3);

      const saveKey = Key('save-recipe-0');
      await _scrollTo(tester, saveKey);
      final save = find.byKey(saveKey);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(find.text('Tarifi kaydetmeden önce kontrol et'), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirm-ai-recipe')));
      await tester.pumpAndSettle();
      expect(meals.records, hasLength(1));
      expect(meals.records.single.source, 'ai_recipe');
      expect(meals.records.single.caloriesKcal, 350);
      expect(meals.records.single.recipeDetailsJson, contains('Sebzeli pilav'));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
