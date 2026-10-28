import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';
import 'package:nutri_buddy/features/analytics/domain/repositories/weightrepository.dart';
import 'package:nutri_buddy/features/analytics/domain/usecases/analytics_snapshot.dart';
import 'package:nutri_buddy/features/analytics/presentation/pages/analytics_page.dart';
import 'package:nutri_buddy/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

class _FakeWeights implements WeightRepository {
  final entries = <WeightEntry>[];
  @override
  Future<List<WeightEntry>> listForUser(String userId) async => entries;
  @override
  Future<void> saveLocally(WeightEntry entry) async => entries.add(entry);
}

/// The analytics cards are built in a single tall Column. Their keys can be
/// found before the controls are actually inside the test viewport.
Future<void> _bringIntoViewport(WidgetTester tester, Finder target) async {
  final scrollView = find.byType(ListView).first;
  for (var attempt = 0; attempt < 16; attempt++) {
    final viewport = tester.getRect(scrollView);
    final rect = tester.getRect(target);
    if (rect.top >= viewport.top && rect.bottom <= viewport.bottom) {
      return;
    }
    final dy = rect.center.dy > viewport.center.dy ? -300.0 : 300.0;
    await tester.drag(scrollView, Offset(0, dy));
    await tester.pumpAndSettle();
  }
  // Fail loudly if the control is genuinely unreachable; do not suppress taps.
  final viewport = tester.getRect(scrollView);
  final rect = tester.getRect(target);
  expect(rect.top, greaterThanOrEqualTo(viewport.top));
  expect(rect.bottom, lessThanOrEqualTo(viewport.bottom));
}

void main() {
  testWidgets('renders explicit no-data state and adds a weight measurement', (
    tester,
  ) async {
    final profile = UserProfile(
      id: 'tester',
      birthDate: DateTime(1995, 1, 1),
      sexForCalculation: 'female',
      heightCm: 166,
      weightKg: 68,
      goal: 'maintain',
      activityLevel: 'light',
      updatedAt: DateTime.utc(2026, 10, 24),
    );
    final t = NutritionCalculator.calculate(profile);
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final fake = _FakeWeights();
    final blank = AnalyticsSnapshot.build(
      userId: 'tester',
      today: day,
      periodDays: 7,
      targets: t,
      meals: [],
      waters: [],
      weights: [],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsSnapshotProvider(
            'tester',
            7,
            day,
            t.dailyCalories,
            t.proteinG,
            t.carbsG,
            t.fatG,
          ).overrideWith((ref) async => blank),
          pendingWeightCountProvider('tester')
              .overrideWith((ref) => Stream.value(0)),
          weightRepositoryProvider.overrideWith((ref) => fake),
          weightCloudSyncProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          home: AnalyticsPage(userId: 'tester', profile: profile),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Veri yok'), findsWidgets);
    final add = find.byKey(const Key('analytics-add-weight'));
    await _bringIntoViewport(tester, add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('analytics-weight-field')), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('analytics-weight-field')),
      '70,4',
    );
    await tester.tap(find.byKey(const Key('analytics-save-weight')));
    await tester.pumpAndSettle();
    expect(fake.entries, hasLength(1));
    expect(fake.entries.single.weightKg, 70.4);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
