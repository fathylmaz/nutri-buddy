import 'package:isar_community/isar.dart';

part 'meal_log_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class MealLogRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String recordId;
  @Index()
  late String userId;
  late DateTime loggedAt;
  late String name;
  String mealType = 'other';
  String source = 'manual';
  int caloriesKcal = 0;
  double proteinG = 0;
  double carbsG = 0;
  double fatG = 0;
  double fiberG = 0;
  bool isEstimate = true;
  String? visionDetailsJson;
  String? recipeDetailsJson;
  bool isDeleted = false;
  DateTime updatedAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool pendingSync = true;
  int serverRevision = 0;
}
