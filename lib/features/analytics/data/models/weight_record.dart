import 'package:isar_community/isar.dart';

part 'weight_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class WeightRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String recordId;
  @Index()
  late String userId;
  late DateTime recordedAt;
  double weightKg = 0;
  bool isDeleted = false;
  bool pendingSync = true;
  DateTime updatedAt = DateTime.fromMillisecondsSinceEpoch(0);
  int serverRevision = 0;
}
