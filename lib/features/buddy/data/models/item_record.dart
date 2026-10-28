import 'package:isar_community/isar.dart';

part 'item_record.g.dart';

/// Isar persistence model. Not shared with domain or presentation layers.
@collection
class ItemRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String recordId;
  @Index(unique: true)
  late String sku;
  late String name;
  late String slot;
  late String assetKey;
  int goldPrice = 0;
  bool active = true;
}
