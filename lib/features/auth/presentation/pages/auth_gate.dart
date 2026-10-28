import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/auth/presentation/pages/auth_page.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';
import 'package:nutri_buddy/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';
import 'package:nutri_buddy/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:nutri_buddy/features/onboarding/presentation/providers/profile_providers.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(authUserIdProvider)
      .when(
        loading: () => const _Loading(),
        error: (error, stack) =>
            _ErrorView(onRetry: () => ref.invalidate(authUserIdProvider)),
        data: (id) {
          if (id == null) {
            return const AuthPage();
          }
          return ref
              .watch(userProfileProvider(id))
              .when(
                loading: () => const _Loading(),
                error: (error, stack) => _ErrorView(
                  onRetry: () => ref.invalidate(userProfileProvider(id)),
                ),
                data: (profile) => _complete(profile)
                    ? DashboardPage(userId: id, profile: profile!)
                    : OnboardingPage(userId: id, initialProfile: profile),
              );
        },
      );

  static bool _complete(UserProfile? p) {
    if (p == null ||
        p.birthDate == null ||
        p.sexForCalculation == null ||
        p.heightCm == null ||
        p.weightKg == null ||
        p.targetWeightKg == null ||
        p.activityLevel == null ||
        p.goal == null) {
      return false;
    }
    try {
      NutritionCalculator.calculate(p);
      return true;
    } on FormatException {
      return false;
    }
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 56),
            const SizedBox(height: 12),
            const Text('Profil alınamadı. Bağlantını kontrol et.'),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Yeniden dene')),
          ],
        ),
      ),
    ),
  );
}
