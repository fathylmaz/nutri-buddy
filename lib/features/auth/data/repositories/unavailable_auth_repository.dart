import 'package:nutri_buddy/features/auth/domain/repositories/auth_repository.dart';

/// Used for widget tests and when SUPABASE_URL is not configured.
final class UnavailableAuthRepository implements AuthRepository {
  @override
  String? get currentUserId => null;

  @override
  Stream<String?> get userChanges => const Stream<String?>.empty();

  @override
  Future<RegisterResult> register({
    required String email,
    required String password,
  }) => Future.error(StateError('Supabase ayarları eksik.'));

  @override
  Future<void> signIn({required String email, required String password}) =>
      Future.error(StateError('Supabase ayarları eksik.'));

  @override
  Future<void> signOut() async {}
}
