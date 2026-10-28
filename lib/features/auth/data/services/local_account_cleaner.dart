import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/features/analytics/data/models/weight_record.dart';
import 'package:nutri_buddy/features/buddy/data/models/pet_record.dart';
import 'package:nutri_buddy/features/buddy/data/models/user_item_record.dart';
import 'package:nutri_buddy/features/dashboard/data/models/water_record.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:nutri_buddy/features/onboarding/data/models/user_record.dart';

/// Deletes the signed-out account's local copies; data is not a secure erase.
/// Caller must warn when unsynced changes would be lost.
final class LocalAccountCleaner {
  const LocalAccountCleaner(this._isar);
  final Isar _isar;

  Future<int> pendingCount(String userId) async =>
      _isar.pendingMutationRecords.filter().userIdEqualTo(userId).count();

  Future<void> clear(String userId) async {
    await _isar.writeTxn(() async {
      await _isar.userRecords.filter().userIdEqualTo(userId).deleteAll();
      await _isar.mealLogRecords.filter().userIdEqualTo(userId).deleteAll();
      await _isar.weightRecords.filter().userIdEqualTo(userId).deleteAll();
      await _isar.waterRecords.filter().userIdEqualTo(userId).deleteAll();
      await _isar.petRecords.filter().userIdEqualTo(userId).deleteAll();
      await _isar.userItemRecords.filter().userIdEqualTo(userId).deleteAll();
      await _isar.pendingMutationRecords
          .filter()
          .userIdEqualTo(userId)
          .deleteAll();
    });
  }
}
