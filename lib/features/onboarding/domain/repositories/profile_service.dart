import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

/// A failed cloud write is never reported as successfully synchronized.
abstract interface class ProfileService {
  Future<UserProfile?> load(String userId);
  Future<ProfileSaveResult> save(UserProfile profile);
  Future<bool> synchronizePending(String userId);
  Future<bool> hasPending(String userId);
}

enum ProfileSaveResult { synchronized, savedLocallyOnly }
