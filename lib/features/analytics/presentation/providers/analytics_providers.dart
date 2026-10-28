import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/analytics/data/repositories/isar_weight_repository.dart';
import 'package:nutri_buddy/features/analytics/data/services/weight_cloud_sync_service.dart';
import 'package:nutri_buddy/features/analytics/domain/repositories/weightrepository.dart';
import 'package:nutri_buddy/features/analytics/domain/usecases/analytics_snapshot.dart';
import 'package:nutri_buddy/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'analytics_providers.g.dart';

@riverpod
WeightRepository weightRepository(Ref ref) =>
    IsarWeightRepository(ref.watch(localDatabaseProvider));

@riverpod
Stream<int> pendingWeightCount(Ref ref, String userId) =>
    IsarWeightRepository(ref.watch(localDatabaseProvider))
        .watchPendingCount(userId);

@riverpod
WeightCloudSyncService? weightCloudSync(Ref ref) {
  if (!AppConfig.cloudConfigured) return null;
  return WeightCloudSyncService(
    ref.watch(localDatabaseProvider),
    Supabase.instance.client,
  );
}

@riverpod
Future<AnalyticsSnapshot> analyticsSnapshot(
  Ref ref,
  String userId,
  int periodDays,
  DateTime today,
  int dailyCalories,
  int proteinG,
  int carbsG,
  int fatG,
) async {
  // Each repository limits reads by the current authenticated user's ID.
  final meals = await ref.watch(mealLogRepositoryProvider).listForUser(userId);
  final waters = await ref.watch(waterRepositoryProvider).listForUser(userId);
  final weights = await ref.watch(weightRepositoryProvider).listForUser(userId);
  return AnalyticsSnapshot.build(
    userId: userId,
    today: today,
    periodDays: periodDays,
    targets: NutritionTargets(
      bmrKcal: 0,
      tdeeKcal: 0,
      dailyCalories: dailyCalories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    ),
    meals: meals,
    waters: waters,
    weights: weights,
  );
}
