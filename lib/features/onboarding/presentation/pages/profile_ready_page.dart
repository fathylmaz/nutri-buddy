import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/account_providers.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';
import 'package:nutri_buddy/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:nutri_buddy/features/onboarding/presentation/providers/profile_providers.dart';

class ProfileReadyPage extends ConsumerStatefulWidget {
  const ProfileReadyPage({
    required this.userId,
    required this.profile,
    super.key,
  });
  final String userId;
  final UserProfile profile;
  @override
  ConsumerState<ProfileReadyPage> createState() => _ProfileReadyPageState();
}

class _ProfileReadyPageState extends ConsumerState<ProfileReadyPage> {
  bool _editing = false;
  bool _busy = false;
  String? _message;

  Future<void> _sync() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final ok = await ref
          .read(profileServiceProvider)
          .synchronizePending(widget.userId);
      if (mounted) ref.invalidate(profilePendingProvider(widget.userId));
      if (mounted) {
        setState(
          () => _message = ok
              ? 'Profil bulutla eşitlendi.'
              : 'İnternet veya izin sorunu: yalnızca yerel kayıt mevcut.',
        );
      }
    } catch (_) {
      if (mounted) setState(() => _message = 'Senkronizasyon başlatılamadı.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    final pending = await ref.read(localPendingCountProvider)(widget.userId);
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış yapılsın mı?'),
        content: Text(
          pending > 0
              ? '$pending eşitlenmemiş yerel değişiklik var. Bu değişiklikler cihazda korunacak; aynı hesapla yeniden girişte eşitleyebilirsin.'
              : 'Oturum kapanacak. Kayıtların cihazda korunacak.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Çıkış yap'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Capture the navigator before the asynchronous sign-out.
    final navigator = Navigator.of(context, rootNavigator: true);

    try {
      await signOutPreservingLocalData(ref);

      // Refresh auth state only while this widget is still mounted.
      if (mounted) {
        ref.invalidate(authUserIdProvider);
      }

      // Close the profile route even if its widget was disposed
      // while the sign-out request was completing.
      if (navigator.mounted) {
        navigator.popUntil((route) => route.isFirst);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message = 'Çıkış işlemi tamamlanamadı. Tekrar dene.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return OnboardingPage(
        userId: widget.userId,
        initialProfile: widget.profile,
        onCancel: () => setState(() => _editing = false),
      );
    }
    final targets = NutritionCalculator.calculate(widget.profile);
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriBuddy'),
        actions: [
          IconButton(
            onPressed: _signOut,
            tooltip: 'Çıkış yap',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Icon(
                  Icons.spa_rounded,
                  size: 66,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Onboarding tamamlandı',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Merhaba ${widget.profile.displayName?.isNotEmpty == true ? widget.profile.displayName : 'arkadaşım'}!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Günlük tahmini hedeflerin',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 14),
                        _metric('Bazal metabolizma', '${targets.bmrKcal} kcal'),
                        _metric('Tahmini TDEE', '${targets.tdeeKcal} kcal'),
                        const Divider(),
                        _metric(
                          'Günlük enerji',
                          '${targets.dailyCalories} kcal',
                        ),
                        _metric('Protein', '${targets.proteinG} g'),
                        _metric('Karbonhidrat', '${targets.carbsG} g'),
                        _metric('Yağ', '${targets.fatG} g'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ref
                    .watch(profilePendingProvider(widget.userId))
                    .when(
                      loading: () => const SizedBox.shrink(),
                      error: (error, stack) =>
                          const Text('Senkronizasyon durumu okunamadı.'),
                      data: (pending) => pending
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  'Buluta gönderilmeyi bekleyen profil değişiklikleri var.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                const Text(
                  'Bu değerler yetişkinler için tahmindir; tıbbi değerlendirme yerine geçmez. Gebelik, emzirme, kronik hastalık veya yeme bozukluğu geçmişinde kişisel uzman görüşü al.',
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _editing = true),
                  icon: const Icon(Icons.edit),
                  label: const Text('Bilgilerimi düzenle'),
                ),
                FilledButton.icon(
                  onPressed: _busy ? null : _sync,
                  icon: const Icon(Icons.sync),
                  label: const Text('Bulut eşitlemesini dene'),
                ),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_message!),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Adım 3 tamamlanma kontrolü: Auth, onboarding ve TDEE. Dashboard, öğün günlüğü ve su takibi sonraki aşamalarda.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
