import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';

/// Implementations belong to data/. Domain never depends on Isar or Supabase.
abstract interface class WeightRepository {
  Future<List<WeightEntry>> listForUser(String userId);
  Future<void> saveLocally(WeightEntry entry);
}
