import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';

/// Implementations belong to data/. Domain never depends on Isar or Supabase.
abstract interface class MealLogRepository {
  Future<MealLog?> getById({required String userId, required String id});
  Future<List<MealLog>> listForUser(String userId);
  Future<void> saveLocally(MealLog log);
  Future<void> markDeleted({required String userId, required String id});
}
