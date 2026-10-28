import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/features/analytics/data/models/weight_record.dart';
import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';
import 'package:nutri_buddy/features/analytics/domain/repositories/weightrepository.dart';

/// Atomic local weight records and an outbox for cloud reconciliation.
final class IsarWeightRepository implements WeightRepository {
  const IsarWeightRepository(this._isar);
  final Isar _isar;

  static WeightEntry _toDomain(WeightRecord r) => WeightEntry(
    id: r.recordId,
    userId: r.userId,
    weightKg: r.weightKg,
    recordedAt: r.recordedAt,
    updatedAt: r.updatedAt,
    isDeleted: r.isDeleted,
  );

  @override
  Future<List<WeightEntry>> listForUser(String userId) async {
    final records = await _isar.weightRecords
        .filter()
        .userIdEqualTo(userId)
        .isDeletedEqualTo(false)
        .sortByRecordedAt()
        .findAll();
    return records.map(_toDomain).toList(growable: false);
  }

  Stream<int> watchPendingCount(String userId) => _isar.weightRecords
      .filter()
      .userIdEqualTo(userId)
      .pendingSyncEqualTo(true)
      .watch(fireImmediately: true)
      .map((rows) => rows.length);

  @override
  Future<void> saveLocally(WeightEntry entry) async {
    if (entry.id.isEmpty ||
        entry.userId.isEmpty ||
        !entry.weightKg.isFinite ||
        entry.weightKg < 10 ||
        entry.weightKg > 500) {
      throw ArgumentError('Invalid weight record');
    }
    await _isar.writeTxn(() async {
      final existing = await _isar.weightRecords
          .filter()
          .recordIdEqualTo(entry.id)
          .findFirst();
      if (existing != null && existing.userId != entry.userId) {
        throw StateError('Cross-account weight update blocked');
      }
      final record = WeightRecord()
        ..id = existing?.id ?? Isar.autoIncrement
        ..recordId = entry.id
        ..userId = entry.userId
        ..weightKg = entry.weightKg
        ..recordedAt = entry.recordedAt.toUtc()
        ..updatedAt = entry.updatedAt.toUtc()
        ..isDeleted = entry.isDeleted
        ..pendingSync = true
        ..serverRevision = existing?.serverRevision ?? 0;
      await _isar.weightRecords.put(record);
      final queued = await _isar.pendingMutationRecords
          .filter()
          .userIdEqualTo(entry.userId)
          .entityTypeEqualTo('weight_entries')
          .entityIdEqualTo(entry.id)
          .findAll();
      await _isar.pendingMutationRecords.deleteAll(
        queued.map((e) => e.id).toList(),
      );
      await _isar.pendingMutationRecords.put(
        PendingMutationRecord()
          ..userId = entry.userId
          ..entityType = 'weight_entries'
          ..entityId = entry.id
          ..operation = entry.isDeleted ? 'delete' : 'upsert'
          ..queuedAt = DateTime.now().toUtc(),
      );
    });
  }

  Future<void> markDeleted({required String userId, required String id}) async {
    final active = await _isar.weightRecords
        .filter()
        .recordIdEqualTo(id)
        .userIdEqualTo(userId)
        .isDeletedEqualTo(false)
        .findFirst();
    if (active == null) return;
    await saveLocally(
      _toDomain(active)
          .copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
    );
  }
}
