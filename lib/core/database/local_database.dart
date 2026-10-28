import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/features/analytics/data/models/weight_record.dart';
import 'package:nutri_buddy/features/buddy/data/models/item_record.dart';
import 'package:nutri_buddy/features/buddy/data/models/pet_record.dart';
import 'package:nutri_buddy/features/buddy/data/models/user_item_record.dart';
import 'package:nutri_buddy/features/dashboard/data/models/water_record.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:nutri_buddy/features/onboarding/data/models/user_record.dart';
import 'package:path_provider/path_provider.dart';

/// Opens all local collections once, before Flutter widgets are mounted.
/// The database is a device cache, not an encrypted vault.
abstract final class LocalDatabase {
  static const name = 'nutri_buddy_v1';

  static Future<Isar> open() async {
    final directory = await getApplicationSupportDirectory();
    return Isar.open(
      [
        UserRecordSchema,
        MealLogRecordSchema,
        PetRecordSchema,
        ItemRecordSchema,
        UserItemRecordSchema,
        WeightRecordSchema,
        WaterRecordSchema,
        PendingMutationRecordSchema,
      ],
      directory: directory.path,
      name: name,
      relaxedDurability: false,
    );
  }
}
