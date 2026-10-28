import 'package:nutri_buddy/features/buddy/domain/entities/buddy_pet.dart';

/// Implementations belong to data/. Domain never depends on Isar or Supabase.
abstract interface class PetRepository {
  Future<BuddyPet?> getForUser(String userId);
}
