import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:nutri_buddy/features/auth/data/repositories/unavailable_auth_repository.dart';
import 'package:nutri_buddy/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (!AppConfig.cloudConfigured) return UnavailableAuthRepository();
  return SupabaseAuthRepository(Supabase.instance.client);
}

/// Start with locally persisted session, then react to auth changes.
@Riverpod(keepAlive: true)
Stream<String?> authUserId(Ref ref) async* {
  final repository = ref.watch(authRepositoryProvider);
  yield repository.currentUserId;
  yield* repository.userChanges;
}
