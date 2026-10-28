import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:nutri_buddy/features/meals/data/services/meal_cloud_sync_service.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'meal_sync_providers.g.dart';

@riverpod
MealCloudSyncService? mealCloudSync(Ref ref) {
  if (!AppConfig.cloudConfigured) {
    return null;
  }
  return MealCloudSyncService(
    ref.watch(localDatabaseProvider),
    Supabase.instance.client,
  );
}

@riverpod
Stream<int> pendingMealCount(Ref ref, String userId) => ref
    .watch(localDatabaseProvider)
    .mealLogRecords
    .filter()
    .userIdEqualTo(userId)
    .pendingSyncEqualTo(true)
    .watch(fireImmediately: true)
    .map((items) => items.length);

@riverpod
Future<List<MealLog>> dailyMeals(Ref ref, String userId, DateTime day) async {
  final logs = await ref.watch(mealLogRepositoryProvider).listForUser(userId);
  return logs.where((log) {
    final local = log.loggedAt.toLocal();
    return local.year == day.year &&
        local.month == day.month &&
        local.day == day.day;
  }).toList();
}
