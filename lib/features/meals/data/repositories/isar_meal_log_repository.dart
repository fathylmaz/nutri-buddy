import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/features/meals/data/mappers/meal_log_mapper.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/meallogrepository.dart';

/// Local-first write path. Remote replay is intentionally NOT implemented yet.
/// A mutation is saved in the same Isar transaction as the corresponding row.
final class IsarMealLogRepository implements MealLogRepository {
  IsarMealLogRepository(this._isar);

  final Isar _isar;

  @override
  Future<MealLog?> getById({required String userId, required String id}) async {
    final record = await _isar.mealLogRecords
        .filter()
        .recordIdEqualTo(id)
        .findFirst();
    if (record == null || record.userId != userId || record.isDeleted) {
      return null;
    }
    return MealLogMapper.toDomain(record);
  }

  @override
  Future<List<MealLog>> listForUser(String userId) async {
    final records = await _isar.mealLogRecords
        .filter()
        .userIdEqualTo(userId)
        .isDeletedEqualTo(false)
        .sortByLoggedAtDesc()
        .findAll();
    return records.map(MealLogMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> saveLocally(MealLog log) async {
    if (log.id.isEmpty || log.userId.isEmpty) {
      throw ArgumentError('MealLog must have stable record and owner IDs');
    }
    if (log.name.trim().isEmpty ||
        log.name.length > 200 ||
        log.caloriesKcal < 0 ||
        log.caloriesKcal > 20000 ||
        !log.proteinG.isFinite ||
        !log.carbsG.isFinite ||
        !log.fatG.isFinite ||
        !log.fiberG.isFinite ||
        log.proteinG < 0 ||
        log.proteinG > 2000 ||
        log.carbsG < 0 ||
        log.carbsG > 2000 ||
        log.fatG < 0 ||
        log.fatG > 2000 ||
        log.fiberG < 0 ||
        log.fiberG > 2000 ||
        !log.fiberG.isFinite) {
      throw ArgumentError('Nutrition quantities cannot be negative');
    }
    await _isar.writeTxn(() async {
      final existing = await _isar.mealLogRecords
          .filter()
          .recordIdEqualTo(log.id)
          .findFirst();
      if (existing != null && existing.userId != log.userId) {
        throw StateError('Cross-account meal log update blocked');
      }
      final record = MealLogMapper.toRecord(log, localId: existing?.id);
      await _isar.mealLogRecords.put(record);
      final previousQueued = await _isar.pendingMutationRecords
          .filter()
          .userIdEqualTo(log.userId)
          .entityTypeEqualTo('logs')
          .entityIdEqualTo(log.id)
          .findAll();
      await _isar.pendingMutationRecords.deleteAll(
        previousQueued.map((row) => row.id).toList(),
      );
      await _isar.pendingMutationRecords.put(
        PendingMutationRecord()
          ..userId = log.userId
          ..entityType = 'logs'
          ..entityId = log.id
          ..operation = log.isDeleted ? 'delete' : 'upsert'
          ..queuedAt = DateTime.now().toUtc(),
      );
    });
  }

  @override
  Future<void> markDeleted({required String userId, required String id}) async {
    final existing = await getById(userId: userId, id: id);
    if (existing == null) {
      return;
    }
    await saveLocally(
      existing.copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
    );
  }
}
