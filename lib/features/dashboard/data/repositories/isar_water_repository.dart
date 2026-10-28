import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/features/dashboard/data/models/water_record.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/dashboard/domain/repositories/waterrepository.dart';

/// All writes are atomic with an outbox entry. The cloud is not required to
/// record water. Stored timestamps are UTC; UI calendar days are local.
final class IsarWaterRepository implements WaterRepository {
  const IsarWaterRepository(this._isar);

  final Isar _isar;

  static DateTime _startUtc(DateTime day) =>
      DateTime(day.year, day.month, day.day).toUtc();

  static DateTime _endUtc(DateTime day) =>
      DateTime(day.year, day.month, day.day + 1).toUtc();

  static WaterEntry _toEntity(WaterRecord record) => WaterEntry(
    id: record.recordId,
    userId: record.userId,
    amountMl: record.amountMl,
    recordedAt: record.recordedAt,
    updatedAt: record.updatedAt,
    isDeleted: record.isDeleted,
  );

  @override
  Future<List<WaterEntry>> listForUser(String userId) async {
    final rows = await _isar.waterRecords
        .filter()
        .userIdEqualTo(userId)
        .isDeletedEqualTo(false)
        .findAll();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Stream<List<WaterEntry>> watchForDay(String userId, DateTime localDay) {
    return _isar.waterRecords
        .filter()
        .userIdEqualTo(userId)
        .isDeletedEqualTo(false)
        .recordedAtBetween(
          _startUtc(localDay),
          _endUtc(localDay),
          includeUpper: false,
        )
        .sortByRecordedAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_toEntity).toList(growable: false));
  }

  @override
  Stream<int> watchPendingCount(String userId) => _isar.waterRecords
      .filter()
      .userIdEqualTo(userId)
      .pendingSyncEqualTo(true)
      .watch(fireImmediately: true)
      .map((rows) => rows.length);

  @override
  Future<void> saveLocally(WaterEntry entry) async {
    if (entry.id.isEmpty || entry.userId.isEmpty) {
      throw ArgumentError('Water entry needs a stable ID and owner ID');
    }
    if (entry.amountMl < 1 || entry.amountMl > 5000) {
      throw ArgumentError.value(entry.amountMl, 'amountMl');
    }
    await _isar.writeTxn(() async {
      final existing = await _isar.waterRecords
          .filter()
          .recordIdEqualTo(entry.id)
          .findFirst();
      if (existing != null && existing.userId != entry.userId) {
        throw StateError('Cross-account water update blocked');
      }
      final record = WaterRecord()
        ..id = existing?.id ?? Isar.autoIncrement
        ..recordId = entry.id
        ..userId = entry.userId
        ..amountMl = entry.amountMl
        ..recordedAt = entry.recordedAt.toUtc()
        ..updatedAt = entry.updatedAt.toUtc()
        ..isDeleted = entry.isDeleted
        ..pendingSync = true
        ..serverRevision = existing?.serverRevision ?? 0;
      await _isar.waterRecords.put(record);
      await _queue(record);
    });
  }

  // Called only inside an existing write transaction.
  Future<void> _queue(WaterRecord record) async {
    final queued = await _isar.pendingMutationRecords
        .filter()
        .userIdEqualTo(record.userId)
        .entityTypeEqualTo('water_entries')
        .entityIdEqualTo(record.recordId)
        .findAll();
    await _isar.pendingMutationRecords.deleteAll([
      for (final item in queued) item.id,
    ]);
    await _isar.pendingMutationRecords.put(
      PendingMutationRecord()
        ..userId = record.userId
        ..entityType = 'water_entries'
        ..entityId = record.recordId
        ..operation = record.isDeleted ? 'delete' : 'upsert'
        ..queuedAt = DateTime.now().toUtc(),
    );
  }

  @override
  Future<bool> undoLastForDay(String userId, DateTime localDay) async {
    return _isar.writeTxn(() async {
      final last = await _isar.waterRecords
          .filter()
          .userIdEqualTo(userId)
          .isDeletedEqualTo(false)
          .recordedAtBetween(
            _startUtc(localDay),
            _endUtc(localDay),
            includeUpper: false,
          )
          .sortByRecordedAtDesc()
          .findFirst();
      if (last == null) {
        return false;
      }
      last.isDeleted = true;
      last.pendingSync = true;
      last.updatedAt = DateTime.now().toUtc();
      await _isar.waterRecords.put(last);
      await _queue(last);
      return true;
    });
  }
}
