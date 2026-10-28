import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/account_providers.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/presentation/pages/profile_ready_page.dart';
import 'package:nutri_buddy/features/onboarding/presentation/providers/profile_providers.dart';

class _FakeAuthRepository implements AuthRepository {
  final _changes = StreamController<String?>.broadcast(sync: true);

  String? _currentUserId = 'test-account';
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
  testWidgets('profile sign-out closes pushed route and shows login', (
    tester,
  ) async {
    final fakeAuth = _FakeAuthRepository();
    addTearDown(fakeAuth.dispose);

    final profile = UserProfile(
      id: 'test-account',
      displayName: 'Deneme',
      birthDate: DateTime(1990, 1, 1),
      sexForCalculation: 'male',
      heightCm: 177,
      weightKg: 79,
      targetWeightKg: 75,
      activityLevel: 'light',
      goal: 'maintain',
      updatedAt: DateTime.utc(2026, 10, 28),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => fakeAuth),
          authUserIdProvider.overrideWith((ref) async* {
            yield fakeAuth.currentUserId;
            yield* fakeAuth.userChanges;
          }),
          localPendingCountProvider.overrideWith(
            (ref) =>
                (String userId) async => 1,
          ),
          profilePendingProvider('test-account')
              .overrideWith((ref) async => false),
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
                    error: (error, stack) =>
                        const Scaffold(body: Text('Auth error')),
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
                                  builder: (context) => ProfileReadyPage(
                                    userId: userId,
                                    profile: profile,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Profili aç'),
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

    // Open the actual profile page.
    await tester.tap(find.text('Profili aç'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileReadyPage), findsOneWidget);

    // Open the sign-out confirmation dialog.
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('1 eşitlenmemiş'), findsOneWidget);

    // Confirm sign-out.
    await tester.tap(find.widgetWithText(FilledButton, 'Çıkış yap'));
    await tester.pumpAndSettle();

    // Authentication was terminated exactly once.
    expect(fakeAuth.signOutCalls, 1);

    // No back-button press should be needed.
    expect(find.text('Giriş ekranı'), findsOneWidget);
    expect(find.byType(ProfileReadyPage), findsNothing);
  });
}
