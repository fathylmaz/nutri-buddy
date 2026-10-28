import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/dashboard/data/repositories/isar_water_repository.dart';
import 'package:nutri_buddy/features/dashboard/data/services/water_cloud_sync_service.dart';
import 'package:nutri_buddy/features/dashboard/domain/repositories/waterrepository.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/water_day_summary.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dashboard_providers.g.dart';

@riverpod
WaterRepository waterRepository(Ref ref) =>
    IsarWaterRepository(ref.watch(localDatabaseProvider));

@Riverpod(keepAlive: true)
WaterCloudSyncService? waterCloudSync(Ref ref) {
  if (!AppConfig.cloudConfigured) {
    return null;
  }
  return WaterCloudSyncService(
    ref.watch(localDatabaseProvider),
    Supabase.instance.client,
  );
}

@riverpod
Stream<WaterDaySummary> waterDay(Ref ref, String userId, DateTime day) => ref
    .watch(waterRepositoryProvider)
    .watchForDay(userId, day)
    .map(
      (entries) => WaterDaySummary.fromEntries(
        userId: userId,
        localDay: day,
        entries: entries,
      ),
    );

@riverpod
Stream<int> pendingWaterCount(Ref ref, String userId) =>
    ref.watch(waterRepositoryProvider).watchPendingCount(userId);

@riverpod
Future<DailyNutritionSummary> dailyNutrition(
  Ref ref,
  String userId,
  DateTime day,
) async {
  final logs = await ref.watch(mealLogRepositoryProvider).listForUser(userId);
  return DailyNutritionSummary.fromLogs(
    userId: userId,
    localDay: day,
    logs: logs,
  );
}
