import 'package:nutri_buddy/features/buddy/domain/entities/store_item.dart';

/// Implementations belong to data/. Domain never depends on Isar or Supabase.
abstract interface class StoreRepository {
  Future<List<StoreItem>> listCatalog();
}
