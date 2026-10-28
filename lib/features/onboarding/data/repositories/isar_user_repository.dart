import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/features/onboarding/data/mappers/user_profile_mapper.dart';
import 'package:nutri_buddy/features/onboarding/data/models/user_record.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/repositories/userrepository.dart';

final class IsarUserRepository implements UserRepository {
  const IsarUserRepository(this._isar);
  final Isar _isar;

  @override
  Future<UserProfile?> getById(String userId) async {
    final row = await _isar.userRecords
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    return row == null ? null : UserProfileMapper.toDomain(row);
  }

  @override
  Stream<UserProfile?> watch(String userId) => _isar.userRecords
      .filter()
      .userIdEqualTo(userId)
      .watch(fireImmediately: true)
      .map(
        (rows) => rows.isEmpty ? null : UserProfileMapper.toDomain(rows.first),
      );

  @override
  Future<void> saveLocally(UserProfile user) => _save(user, enqueue: true);

  Future<void> cacheFromServer(UserProfile user) => _save(user, enqueue: false);

  Future<void> _save(UserProfile user, {required bool enqueue}) async {
    await _isar.writeTxn(() async {
      final current = await _isar.userRecords
          .filter()
          .userIdEqualTo(user.id)
          .findFirst();
      final record = UserProfileMapper.toRecord(user, localId: current?.id)
        ..pendingSync = enqueue;
      await _isar.userRecords.put(record);
      if (enqueue) {
        // Deduplicate profile requests so repeated edits only replay latest state.
        final queued = await _isar.pendingMutationRecords
            .filter()
            .userIdEqualTo(user.id)
            .findAll();
        await _isar.pendingMutationRecords.deleteAll([
          for (final mutation in queued)
            if (mutation.entityType == 'users') mutation.id,
        ]);
        await _isar.pendingMutationRecords.put(
          PendingMutationRecord()
            ..userId = user.id
            ..entityType = 'users'
            ..entityId = user.id
            ..operation = 'upsert'
            ..queuedAt = DateTime.now().toUtc(),
        );
      }
    });
  }

  Future<void> markSynced(UserProfile expected) async {
    await _isar.writeTxn(() async {
      final row = await _isar.userRecords
          .filter()
          .userIdEqualTo(expected.id)
          .findFirst();
      if (row == null ||
          row.updatedAt.millisecondsSinceEpoch !=
              expected.updatedAt.millisecondsSinceEpoch) {
        return;
      }
      row.pendingSync = false;
      await _isar.userRecords.put(row);
      final queued = await _isar.pendingMutationRecords
          .filter()
          .userIdEqualTo(expected.id)
          .findAll();
      await _isar.pendingMutationRecords.deleteAll([
        for (final mutation in queued)
          if (mutation.entityType == 'users') mutation.id,
      ]);
    });
  }

  Future<bool> hasPending(String userId) async {
    final row = await _isar.userRecords
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    return row?.pendingSync ?? false;
  }
}
