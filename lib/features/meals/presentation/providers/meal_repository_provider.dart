import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/meals/data/repositories/isar_meal_log_repository.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/meallogrepository.dart';

final mealLogRepositoryProvider = Provider<MealLogRepository>((ref) {
  return IsarMealLogRepository(ref.watch(localDatabaseProvider));
});
