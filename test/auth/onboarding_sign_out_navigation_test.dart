import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/account_providers.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';
import 'package:nutri_buddy/features/onboarding/presentation/pages/onboarding_page.dart';

class _FakeAuthRepository implements AuthRepository {
  final _changes = StreamController<String?>.broadcast(sync: true);

  String? _currentUserId = 'onboarding-user';
  int signOutCalls = 0;

  @override
  String? get currentUserId => _currentUserId;

  @override
  Stream<String?> get userChanges => _changes.stream;

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _currentUserId = null;
    _changes.add(null);
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

  Future<void> dispose() => _changes.close();
}

void main() {
  testWidgets(
    'onboarding sign-out preserves pending data and returns to login',
    (tester) async {
      final fakeAuth = _FakeAuthRepository();
      final pendingRequests = <String>[];

      addTearDown(fakeAuth.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWith((ref) => fakeAuth),
            authUserIdProvider.overrideWith((ref) async* {
              yield fakeAuth.currentUserId;
              yield* fakeAuth.userChanges;
            }),
            localPendingCountProvider.overrideWith(
              (ref) => (String userId) async {
                pendingRequests.add(userId);
                return 2;
              },
            ),
            localAccountCleanerProvider.overrideWith(
              (ref) =>
                  throw StateError('LocalAccountCleaner must not be accessed.'),
            ),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                return ref
                    .watch(authUserIdProvider)
                    .when(
                      loading: () => const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => const Scaffold(
                        body: Center(child: Text('Auth error')),
                      ),
                      data: (userId) {
                        if (userId == null) {
                          return const Scaffold(
                            body: Center(child: Text('Giriş ekranı')),
                          );
                        }

                        return Scaffold(
                          body: Center(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) =>
                                        OnboardingPage(userId: userId),
                                  ),
                                );
                              },
                              child: const Text('Onboarding aç'),
                            ),
                          ),
                        );
                      },
                    );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open the real onboarding page.
      await tester.tap(find.text('Onboarding aç'));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingPage), findsOneWidget);

      // Open sign-out confirmation.
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('2 kayıt'), findsOneWidget);
      expect(fakeAuth.signOutCalls, 0);

      // Cancelling must leave the user signed in.
      await tester.tap(find.widgetWithText(TextButton, 'Vazgeç'));
      await tester.pumpAndSettle();

      expect(fakeAuth.signOutCalls, 0);
      expect(find.byType(OnboardingPage), findsOneWidget);

      // Open confirmation again and confirm sign-out.
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Çıkış yap'));
      await tester.pumpAndSettle();

      // The account was signed out exactly once.
      expect(fakeAuth.signOutCalls, 1);

      // The pending count was checked for the correct owner.
      expect(pendingRequests, ['onboarding-user', 'onboarding-user']);

      // The login screen appears without pressing Back.
      expect(find.text('Giriş ekranı'), findsOneWidget);
      expect(find.byType(OnboardingPage), findsNothing);
    },
  );
}
