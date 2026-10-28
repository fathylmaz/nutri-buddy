import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/buddy/data/repositories/isar_pet_repository.dart';
import 'package:nutri_buddy/features/buddy/data/services/buddy_cloud_service.dart';
import 'package:nutri_buddy/features/buddy/domain/entities/buddy_pet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'buddy_providers.g.dart';

@riverpod
IsarPetRepository buddyLocalRepository(Ref ref) =>
    IsarPetRepository(ref.watch(localDatabaseProvider));

@riverpod
BuddyCloudService? buddyCloudService(Ref ref) {
  if (!AppConfig.cloudConfigured) return null;
  return BuddyCloudService(
    Supabase.instance.client,
    ref.watch(buddyLocalRepositoryProvider),
  );
}

@riverpod
Stream<BuddyPet?> buddyPet(Ref ref, String userId) =>
    ref.watch(buddyLocalRepositoryProvider).watchForUser(userId);
