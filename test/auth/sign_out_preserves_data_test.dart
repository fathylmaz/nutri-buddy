import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/account_providers.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';

class _FakeAuthRepository implements AuthRepository {
  int signOutCalls = 0;

  @override
  String? get currentUserId => 'test-account';

  @override
  Stream<String?> get userChanges => const Stream<String?>.empty();

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<RegisterResult> register({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets(
    'sign-out calls auth repository without accessing local cleaner',
    (tester) async {
      final fakeAuth = _FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWith((ref) => fakeAuth),
            localAccountCleanerProvider.overrideWith(
              (ref) => throw StateError(
                'Local cleaner must not be accessed during sign-out.',
              ),
            ),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                return Scaffold(
                  body: Center(
                    child: FilledButton(
                      onPressed: () async {
                        await signOutPreservingLocalData(ref);
                      },
                      child: const Text('Test sign out'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test sign out'));
      await tester.pumpAndSettle();

      expect(fakeAuth.signOutCalls, 1);
    },
  );
}
