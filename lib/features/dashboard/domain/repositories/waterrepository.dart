import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';

/// Domain-only contract; infrastructure implementations stay in data/.
abstract interface class WaterRepository {
  Future<List<WaterEntry>> listForUser(String userId);
  Stream<List<WaterEntry>> watchForDay(String userId, DateTime localDay);
  Stream<int> watchPendingCount(String userId);
  Future<void> saveLocally(WaterEntry entry);
  Future<bool> undoLastForDay(String userId, DateTime localDay);
}
