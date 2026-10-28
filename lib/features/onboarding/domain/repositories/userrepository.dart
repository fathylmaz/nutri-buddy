import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

/// Implementations belong to data/. Domain never depends on Isar or Supabase.
abstract interface class UserRepository {
  Future<UserProfile?> getById(String userId);
  Future<void> saveLocally(UserProfile user);
  Stream<UserProfile?> watch(String userId);
}
