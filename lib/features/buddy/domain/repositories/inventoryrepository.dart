import 'package:nutri_buddy/features/buddy/domain/entities/user_item.dart';

/// Implementations belong to data/. Domain never depends on Isar or Supabase.
abstract interface class InventoryRepository {
  Future<List<UserItem>> listOwned(String userId);
}
