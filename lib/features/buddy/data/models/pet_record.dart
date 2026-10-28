import 'package:isar_community/isar.dart';

part 'pet_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class PetRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;
  late String recordId;
  String mood = 'neutral';
  int xp = 0;
  int gold = 0;
  int level = 1;
  int streakDays = 0;
  DateTime updatedAt = DateTime.fromMillisecondsSinceEpoch(0);
  int serverRevision = 0;
}
