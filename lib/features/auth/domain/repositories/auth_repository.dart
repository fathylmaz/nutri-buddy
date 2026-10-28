/// An authenticated account is required before accessing private profile data.
abstract interface class AuthRepository {
  String? get currentUserId;
  Stream<String?> get userChanges;
  Future<RegisterResult> register({
    required String email,
    required String password,
  });
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}

enum RegisterResult { signedIn, emailConfirmationRequired }
