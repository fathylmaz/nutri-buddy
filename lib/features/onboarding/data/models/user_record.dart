import 'package:isar_community/isar.dart';

part 'user_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class UserRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;
  String? displayName;
  String? sexForCalculation;
  DateTime? birthDate;
  double? heightCm;
  double? weightKg;
  double? targetWeightKg;
  String? goal;
  String? activityLevel;
  List<String> allergies = [];
  List<String> chronicConditions = [];
  String timezone = 'UTC';
  DateTime updatedAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool pendingSync = false;
  int serverRevision = 0;
}
