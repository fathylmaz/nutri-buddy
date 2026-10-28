import 'package:isar_community/isar.dart';

part 'pending_mutation_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class PendingMutationRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;
  late String entityType;
  late String entityId;
  String operation = 'upsert';
  DateTime queuedAt = DateTime.fromMillisecondsSinceEpoch(0);
  int retryCount = 0;
  DateTime? retryAfter;
}
