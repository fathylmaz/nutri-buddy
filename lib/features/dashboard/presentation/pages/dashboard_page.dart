import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/sync/account_cloud_restore_service.dart';
import 'package:nutri_buddy/features/ai_dietitian/presentation/dietitian_page.dart';
import 'package:nutri_buddy/features/analytics/presentation/pages/analytics_page.dart';
import 'package:nutri_buddy/features/buddy/presentation/pages/buddy_page.dart';
import 'package:nutri_buddy/features/dashboard/domain/entities/water_entry.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/water_day_summary.dart';
import 'package:nutri_buddy/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:nutri_buddy/features/dashboard/presentation/widgets/progress_ring.dart';
import 'package:nutri_buddy/features/dashboard/presentation/widgets/water_wave_gauge.dart';
import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';
import 'package:nutri_buddy/features/meal_builder/presentation/pages/meal_builder_page.dart';
import 'package:nutri_buddy/features/meal_builder/presentation/pages/recipe_details_page.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/presentation/pages/meal_logger_page.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_sync_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';
import 'package:nutri_buddy/features/onboarding/presentation/pages/profile_ready_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({required this.userId, required this.profile, super.key});

  final String userId;
  final UserProfile profile;

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with WidgetsBindingObserver {
  static final Random _secureRandom = Random.secure();
  late DateTime _day;
  Timer? _midnightTimer;
  bool _writing = false;
  bool _syncing = false;
  bool _restoring = false;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _day = _today();
    WidgetsBinding.instance.addObserver(this);
    _scheduleMidnightRefresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_restoreCloud(silent: true));
      }
    });
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final next = DateTime(now.year, now.month, now.day + 1);
    _midnightTimer = Timer(
      next.difference(now) + const Duration(seconds: 1),
      () {
        if (!mounted) {
          return;
        }
        _refreshDay();
        _scheduleMidnightRefresh();
      },
    );
  }

  void _refreshDay() {
    final today = _today();
    if (today != _day) {
      setState(() => _day = today);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshDay();
      _scheduleMidnightRefresh();
      unawaited(_restoreCloud(silent: true));
    }
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  static String _makeUuid() {
    final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  Future<void> _addWater() async {
    if (_writing) {
      return;
    }
    setState(() {
      _writing = true;
      _notice = null;
    });
    try {
      final now = DateTime.now().toUtc();
      await ref
          .read(waterRepositoryProvider)
          .saveLocally(
            WaterEntry(
              id: _makeUuid(),
              userId: widget.userId,
              amountMl: WaterDaySummary.glassSizeMl,
              recordedAt: now,
              updatedAt: now,
            ),
          );
      if (mounted) {
        setState(() => _notice = '+250 ml yerel veritabanına kaydedildi.');
        unawaited(_sync(silent: true));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _notice = 'Su kaydı başarısız. Tekrar dene.');
      }
    } finally {
      if (mounted) {
        setState(() => _writing = false);
      }
    }
  }

  Future<void> _undoWater() async {
    if (_writing) {
      return;
    }
    setState(() {
      _writing = true;
      _notice = null;
    });
    try {
      final ok = await ref
          .read(waterRepositoryProvider)
          .undoLastForDay(widget.userId, _day);
      if (mounted) {
        setState(
          () => _notice = ok
              ? 'Son su kaydı geri alındı.'
              : 'Bugün geri alınacak kayıt yok.',
        );
        if (ok) {
          unawaited(_sync(silent: true));
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _notice = 'Geri alma işlemi başarısız.');
      }
    } finally {
      if (mounted) {
        setState(() => _writing = false);
      }
    }
  }

  Future<void> _sync({bool silent = false}) async {
    if (_syncing) {
      return;
    }
    final service = ref.read(waterCloudSyncProvider);
    if (service == null) {
      if (!silent && mounted) {
        setState(
          () => _notice =
              'Bulut bağlantısı yapılandırılmadı. Yerel kayıtlar güvende.',
        );
      }
      return;
    }
    if (mounted) {
      setState(() => _syncing = true);
    }
    try {
      await service
          .syncPending(widget.userId)
          .timeout(const Duration(seconds: 8));
      if (!silent && mounted) {
        setState(() => _notice = 'Bekleyen su kayıtları eşitlendi.');
      }
    } catch (_) {
      if (!silent && mounted) {
        setState(
          () => _notice = 'Buluta ulaşılamadı. Yerel kayıtlar korunuyor.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _syncing = false);
      }
    }
  }

  Future<void> _syncMeals() async {
    final service = ref.read(mealCloudSyncProvider);
    if (service == null) {
      return;
    }
    try {
      await service
          .syncPending(widget.userId)
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      // Pending outbox remains. Explicit status is visible on the meals card.
    }
  }

  Future<void> _restoreCloud({bool silent = false}) async {
    if (_restoring) return;
    final service = ref.read(accountCloudRestoreProvider);
    if (service == null) {
      if (!silent && mounted) {
        setState(() => _notice = 'Bulut bağlantısı yapılandırılmadı.');
      }
      return;
    }
    if (mounted) setState(() => _restoring = true);
    try {
      final result = await service
          .restore(widget.userId)
          .timeout(const Duration(seconds: 45));
      if (!mounted) return;
      _refreshMeals();
      ref.invalidate(dailyNutritionProvider(widget.userId, _day));
      setState(
        () => _notice =
            'Buluttan getirilen: ${result.meals} öğün, '
            '${result.waters} su, ${result.weights} kilo kaydı.'
            '${result.uploadsComplete ? '' : ' Bazı yerel kayıtların eşitlemesi bekliyor.'}',
      );
    } catch (_) {
      if (!silent && mounted) {
        setState(
          () => _notice = 'Bulut kayıtları alınamadı. Yerel veriler silinmedi; bağlantını kontrol et.',
        );
      }
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  void _refreshMeals() {
    ref.invalidate(dailyNutritionProvider(widget.userId, _day));
    ref.invalidate(dailyMealsProvider(widget.userId, _day));
  }

  Future<void> _openMealLogger() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => MealLoggerPage(userId: widget.userId),
      ),
    );
    if (!mounted) {
      return;
    }
    if (saved == true) {
      _refreshMeals();
      setState(() => _notice = 'Öğün kaydedildi. Bulut eşitlemesi deneniyor.');
      unawaited(_syncMeals());
    }
  }

  Future<void> _openMealBuilder() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            MealBuilderPage(userId: widget.userId, profile: widget.profile),
      ),
    );
    if (!mounted) {
      return;
    }
    if (saved == true) {
      _refreshMeals();
      setState(() => _notice = 'AI tarifi öğün günlüğüne kaydedildi.');
      unawaited(_syncMeals());
    }
  }

  Future<void> _openSavedRecipe(MealLog log) async {
    final details = log.recipeDetailsJson;
    if (details == null) {
      return;
    }
    try {
      final decoded = jsonDecode(details);
      if (decoded is! Map) {
        throw const FormatException('Tarif kaydı okunamıyor.');
      }
      final recipe = MealRecipe.fromJson(Map<String, dynamic>.from(decoded));
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => RecipeDetailsPage(recipe: recipe),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarif ayrıntıları okunamadı.')),
        );
      }
    }
  }

  Future<void> _deleteMeal(MealLog meal) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Öğün silinsin mi?'),
        content: Text('“${meal.name}” kaydı günlük toplamdan çıkarılacak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) {
      return;
    }
    try {
      await ref
          .read(mealLogRepositoryProvider)
          .markDeleted(userId: widget.userId, id: meal.id);
      if (!mounted) {
        return;
      }
      _refreshMeals();
      unawaited(_syncMeals());
    } catch (_) {
      if (mounted) {
        setState(() => _notice = 'Öğün silinemedi. Tekrar dene.');
      }
    }
  }

  Future<void> _openBuddy() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (context) => BuddyPage(userId: widget.userId)),
    );
  }

  Future<void> _openDietitian() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) =>
            DietitianPage(userId: widget.userId, profile: widget.profile),
      ),
    );
  }

  Future<void> _openAnalytics() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) =>
            AnalyticsPage(userId: widget.userId, profile: widget.profile),
      ),
    );
    if (!mounted) return;
    // Analytics is local-first; refresh dashboard after returning.
    _refreshMeals();
  }

  Future<void> _openProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            ProfileReadyPage(userId: widget.userId, profile: widget.profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targets = NutritionCalculator.calculate(widget.profile);
    final nutrition = ref.watch(dailyNutritionProvider(widget.userId, _day));
    final water = ref.watch(waterDayProvider(widget.userId, _day));
    final pending = ref.watch(pendingWaterCountProvider(widget.userId));
    final scheme = Theme.of(context).colorScheme;
    final displayName = widget.profile.displayName?.trim();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NutriBuddy',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            key: const Key('open-dietitian'),
            tooltip: 'AI Beslenme Asistanı',
            onPressed: _openDietitian,
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          IconButton(
            key: const Key('open-buddy'),
            tooltip: 'Buddy arkadaşım',
            onPressed: _openBuddy,
            icon: const Icon(Icons.pets_rounded),
          ),
          IconButton(
            key: const Key('open-analytics'),
            tooltip: 'Analizler ve grafikler',
            onPressed: _openAnalytics,
            icon: const Icon(Icons.insights_outlined),
          ),
          IconButton(
            tooltip: 'Profil ve çıkış ayarları',
            onPressed: _openProfile,
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dailyNutritionProvider(widget.userId, _day));
                _refreshMeals();
                await _sync(silent: false);
                await _syncMeals();
                await _restoreCloud(silent: false);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 34),
                children: [
                  Text(
                    'Bugün kendine iyi bak 🌿',
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: scheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Merhaba, ${displayName?.isNotEmpty == true ? displayName : 'arkadaşım'}',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Günlük ilerlemen • ${_day.day}.${_day.month}.${_day.year}',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 18),
                  _nutritionCard(
                    context,
                    nutrition,
                    targets.dailyCalories,
                    targets.proteinG,
                    targets.carbsG,
                    targets.fatG,
                  ),
                  const SizedBox(height: 16),
                  _mealsCard(context),
                  const SizedBox(height: 16),
                  _waterCard(context, water, pending),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: scheme.primary),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Makrolar, kaydedilen öğünlerden hesaplanır. '
                              'Fotoğrafla öğün analizi tahminidir; kaydetmeden önce doğrula. '
                              'Günlük hedefler tıbbi öneri değildir.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mealsCard(BuildContext context) {
    final meals = ref.watch(dailyMealsProvider(widget.userId, _day));
    final pending = ref.watch(pendingMealCountProvider(widget.userId));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant_menu_rounded),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Öğün günlüğü',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FilledButton.tonalIcon(
                  key: const Key('add-meal'),
                  onPressed: _openMealLogger,
                  icon: const Icon(Icons.add),
                  label: const Text('Öğün ekle'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            pending.when(
              data: (count) => Text(
                count == 0
                    ? 'Yerel öğünler eşitlenmiş görünüyor.'
                    : '$count öğün buluta gönderilmeyi bekliyor.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              loading: () => const Text('Eşitleme durumu okunuyor...'),
              error: (error, trace) => const Text('Eşitleme durumu okunamadı.'),
            ),
            OutlinedButton.icon(
              key: const Key('open-meal-builder'),
              onPressed: _openMealBuilder,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AI ile tarif oluştur'),
            ),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: _syncMeals,
              icon: const Icon(Icons.sync),
              label: const Text('Öğünleri eşitle'),
            ),
            OutlinedButton.icon(
              key: const Key('restore-cloud-records'),
              onPressed: _restoring ? null : () => _restoreCloud(silent: false),
              icon: _restoring
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: const Text('Buluttaki geçmişimi geri getir'),
            ),
            meals.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, trace) => const Text('Öğünler yüklenemedi.'),
              data: (items) => items.isEmpty
                  ? const Text(
                      'Bugün kayıtlı öğün yok. Fotoğraf veya manuel giriş ekle.',
                    )
                  : Column(
                      children: [
                        for (final meal in items)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.lunch_dining_outlined),
                            title: Text(meal.name),
                            subtitle: Text(
                              '${meal.caloriesKcal} kcal · '
                              '${meal.proteinG.toStringAsFixed(1)} g protein'
                              '${meal.isEstimate ? ' · tahmin' : ''}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (meal.recipeDetailsJson != null)
                                  IconButton(
                                    tooltip: 'Kaydedilen tarifi aç',
                                    onPressed: () => _openSavedRecipe(meal),
                                    icon: const Icon(Icons.menu_book_outlined),
                                  ),
                                IconButton(
                                  tooltip: 'Öğünü sil',
                                  onPressed: () => _deleteMeal(meal),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionCard(
    BuildContext context,
    AsyncValue<DailyNutritionSummary> data,
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Günlük beslenme',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              'Öğünlerden hesaplanan tüketim ve kişisel hedeflerin',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, trace) =>
                  const Text('Öğün kayıtları yüklenemedi.'),
              data: (summary) => Column(
                children: [
                  Center(
                    child: ProgressRing(
                      consumed: summary.caloriesKcal,
                      target: calories,
                      centerText: '${summary.caloriesKcal}',
                      caption: '/ $calories kcal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    summary.mealCount == 0
                        ? 'Bugün henüz öğün kaydı yok.'
                        : '${summary.mealCount} öğün kaydedildi.',
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _MacroTile(
                          label: 'Protein',
                          amount: summary.proteinG,
                          goal: protein,
                          tint: const Color(0xFF9A66D1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MacroTile(
                          label: 'Karb.',
                          amount: summary.carbsG,
                          goal: carbs,
                          tint: const Color(0xFFE3A135),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MacroTile(
                          label: 'Yağ',
                          amount: summary.fatG,
                          goal: fat,
                          tint: const Color(0xFF2E9E86),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterCard(
    BuildContext context,
    AsyncValue<WaterDaySummary> water,
    AsyncValue<int> pending,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop_rounded, color: Color(0xFF269ED0)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Su takibi',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            water.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, trace) => const Text('Su kayıtları okunamadı.'),
              data: (summary) => Row(
                children: [
                  WaterWaveGauge(fraction: summary.fraction),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${summary.consumedMl} ml',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          '${summary.goalMl} ml görsel referans hedefi',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${summary.glassCount} kayıt • %${(summary.fraction * 100).round()}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          key: const Key('add-water'),
                          onPressed: _writing ? null : _addWater,
                          icon: const Icon(Icons.add),
                          label: const Text('+ 250 ml'),
                        ),
                        TextButton.icon(
                          key: const Key('undo-water'),
                          onPressed: _writing || summary.glassCount == 0
                              ? null
                              : _undoWater,
                          icon: const Icon(Icons.undo, size: 17),
                          label: const Text('Son kaydı geri al'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Su referansı kişisel tıbbi sıvı ihtiyacın değildir; '
              'ihtiyaçlar kişiye ve koşullara göre değişir.',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.cloud_outlined,
                  size: 17,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    pending.when(
                      loading: () => 'Eşitleme durumu kontrol ediliyor…',
                      error: (error, trace) => 'Eşitleme durumu okunamadı.',
                      data: (count) => count == 0
                          ? 'Su kayıtları için bekleyen değişiklik yok.'
                          : '$count su kaydı buluta gönderilmeyi bekliyor.',
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Bekleyen su kayıtlarını eşitle',
                  onPressed: _syncing ? null : () => _sync(),
                  icon: _syncing
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                ),
              ],
            ),
            if (_notice != null)
              Text(
                _notice!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: scheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({
    required this.label,
    required this.amount,
    required this.goal,
    required this.tint,
  });

  final String label;
  final double amount;
  final int goal;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final fraction = goal <= 0
        ? 0.0
        : (amount / goal).clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        Text(
          '${amount.round()} / $goal g',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(end: fraction),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 650),
          builder: (context, value, child) => LinearProgressIndicator(
            value: value,
            minHeight: 7,
            borderRadius: BorderRadius.circular(9),
            valueColor: AlwaysStoppedAnimation<Color>(tint),
          ),
        ),
      ],
    );
  }
}
