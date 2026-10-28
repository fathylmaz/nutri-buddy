import 'package:isar_community/isar.dart';

part 'user_item_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class UserItemRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String recordId;
  @Index()
  late String userId;
  late String itemId;
  late DateTime acquiredAt;
  bool equipped = false;
}
