import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/onboarding/data/repositories/isar_user_repository.dart';
import 'package:nutri_buddy/features/onboarding/data/repositories/offline_first_profile_service.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/repositories/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_providers.g.dart';

@riverpod
IsarUserRepository localUserRepository(Ref ref) =>
    IsarUserRepository(ref.watch(localDatabaseProvider));

@riverpod
ProfileService profileService(Ref ref) {
  if (!AppConfig.cloudConfigured) {
    throw StateError('Supabase yapılandırması olmadan profil eşitlenemez.');
  }
  return OfflineFirstProfileService(
    ref.watch(localUserRepositoryProvider),
    Supabase.instance.client,
  );
}

@riverpod
Future<UserProfile?> userProfile(Ref ref, String userId) =>
    ref.watch(profileServiceProvider).load(userId);

@riverpod
Future<bool> profilePending(Ref ref, String userId) =>
    ref.watch(profileServiceProvider).hasPending(userId);
