import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/analytics/data/repositories/isar_weight_repository.dart';
import 'package:nutri_buddy/features/analytics/domain/entities/weight_entry.dart';
import 'package:nutri_buddy/features/analytics/domain/usecases/analytics_snapshot.dart';
import 'package:nutri_buddy/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

/// A local-first record dashboard; no AI calls and no inferred missing days.
class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({required this.userId, required this.profile, super.key});

  final String userId;
  final UserProfile profile;

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage>
    with WidgetsBindingObserver {
  int _periodDays = 7;
  late DateTime _day;
  bool _busy = false;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _day = _today();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_syncWeight(silent: true));
    });
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _day = _today());
      _refresh();
      unawaited(_syncWeight(silent: true));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  NutritionTargets get _targets =>
      NutritionCalculator.calculate(widget.profile);

  void _refresh() {
    final t = _targets;
    ref.invalidate(
      analyticsSnapshotProvider(
        widget.userId,
        _periodDays,
        _day,
        t.dailyCalories,
        t.proteinG,
        t.carbsG,
        t.fatG,
      ),
    );
  }

  Future<void> _syncWeight({bool silent = false}) async {
    final service = ref.read(weightCloudSyncProvider);
    if (service == null) {
      if (!silent && mounted) {
        setState(
          () => _notice = 'Bulut yapılandırılmadı; ölçümler yerelde güvende.',
        );
      }
      return;
    }
    try {
      await service
          .syncPending(widget.userId)
          .timeout(const Duration(seconds: 12));
      if (!silent && mounted) {
        setState(() => _notice = 'Bekleyen kilo ölçümleri eşitlendi.');
      }
    } catch (_) {
      if (!silent && mounted) {
        setState(() => _notice = 'Eşitleme olmadı; yerel ölçümler korunuyor.');
      }
    }
  }

  Future<void> _addWeight() async {
    if (_busy) return;
    final value = await showDialog<double>(
      context: context,
      builder: (dialogContext) => const _WeightEntryDialog(),
    );
    if (value == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final now = DateTime.now().toUtc();
      final entry = WeightEntry(
        id: _uuid(),
        userId: widget.userId,
        weightKg: value,
        recordedAt: now,
        updatedAt: now,
      );
      await ref.read(weightRepositoryProvider).saveLocally(entry);
      if (!mounted) return;
      _refresh();
      setState(() => _notice = 'Ölçüm Isar veritabanına kaydedildi.');
      unawaited(_syncWeight(silent: true));
    } catch (_) {
      if (mounted) setState(() => _notice = 'Ölçüm kaydedilemedi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // Cryptographically strong random is used for client-side UUIDs.
  static final _random = math.Random.secure();
  static String _uuid() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> _deleteWeight(WeightEntry entry) async {
    if (_busy) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Kilo ölçümü silinsin mi?'),
        content: Text(
          '${entry.weightKg.toStringAsFixed(1)} kg kaydı kaldırılacak.',
        ),
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
    if (yes != true || !mounted) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(weightRepositoryProvider);
      if (repo is! IsarWeightRepository) {
        // Injected test repositories can expose saveLocally without delete.
        await repo.saveLocally(
          entry.copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
        );
      } else {
        await repo.markDeleted(userId: widget.userId, id: entry.id);
      }
      if (!mounted) return;
      _refresh();
      setState(() => _notice = 'Ölçüm kaldırıldı.');
      unawaited(_syncWeight(silent: true));
    } catch (_) {
      if (mounted) setState(() => _notice = 'Ölçüm silinemedi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _targets;
    final snapshot = ref.watch(
      analyticsSnapshotProvider(
        widget.userId,
        _periodDays,
        _day,
        t.dailyCalories,
        t.proteinG,
        t.carbsG,
        t.fatG,
      ),
    );
    final pending = ref.watch(pendingWeightCountProvider(widget.userId));
    return Scaffold(
      appBar: AppBar(title: const Text('Analizler ve grafikler')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _day = _today());
            _refresh();
            await _syncWeight(silent: false);
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  Text(
                    'Gelişimini takip et',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Yalnızca bu cihazdaki kayıtlar gösterilir. '
                    'Boş günler sıfır tüketim sayılmaz.',
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<int>(
                    key: const Key('analytics-period'),
                    segments: const [
                      ButtonSegment(value: 7, label: Text('7 gün')),
                      ButtonSegment(value: 30, label: Text('30 gün')),
                      ButtonSegment(value: 90, label: Text('90 gün')),
                    ],
                    selected: {_periodDays},
                    onSelectionChanged: (value) =>
                        setState(() => _periodDays = value.first),
                  ),
                  const SizedBox(height: 14),
                  if (_notice != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(_notice!, key: const Key('analytics-notice')),
                    ),
                  snapshot.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(42),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text('Grafik kayıtları yüklenemedi.'),
                            TextButton(
                              onPressed: _refresh,
                              child: const Text('Tekrar dene'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (data) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _summaryCard(context, data),
                        const SizedBox(height: 12),
                        _calorieCard(context, data),
                        const SizedBox(height: 12),
                        _macroCard(context, data),
                        const SizedBox(height: 12),
                        _waterCard(context, data),
                        const SizedBox(height: 12),
                        _weightCard(context, data, pending),
                        const SizedBox(height: 12),
                        _recentDaysCard(context, data),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Grafikler kayıt bazlı istatistiklerdir; eksik günler '
                    'gösterilmez veya ortalamaya dahil edilmez. '
                    'Kilo ve enerji hedefleri tıbbi değerlendirme yerine geçmez.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(BuildContext context, AnalyticsSnapshot a) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_periodDays günlük özet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text('Öğün kaydı olan günler: ${a.loggedMealDays} / $_periodDays'),
          Text('Su kaydı olan günler: ${a.loggedWaterDays} / $_periodDays'),
          Text(
            'Ortalama enerji: ${_format(a.averageCaloriesLoggedDays, 'kcal')}',
          ),
          Text(
            'Hedefin ±%10 aralığında: ${a.calorieNearTargetDays} kayıtlı gün',
          ),
          const SizedBox(height: 4),
          const Text('Ortalama yalnızca kayıt girilen günlerden hesaplanır.'),
        ],
      ),
    ),
  );

  Widget _calorieCard(BuildContext context, AnalyticsSnapshot a) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kalori eğilimi', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Güncel günlük hedef: ${a.calorieTarget} kcal'),
          const SizedBox(height: 12),
          if (a.loggedMealDays == 0)
            const Text('Henüz öğün kaydı yok; kalori grafiği oluşturulamıyor.')
          else
            _calendarBars(
              a.days,
              (d) => d.hasMeals ? d.caloriesKcal.toDouble() : null,
              reference: a.calorieTarget.toDouble(),
              color: Theme.of(context).colorScheme.primary,
              label: 'Kalori',
            ),
        ],
      ),
    ),
  );

  Widget _macroCard(BuildContext context, AnalyticsSnapshot a) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ortalama makrolar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text('Yalnızca öğün kayıtlı günlerin ortalaması'),
          const SizedBox(height: 12),
          _macroRow(
            context,
            'Protein',
            a.averageProteinLoggedDays,
            a.proteinTarget,
          ),
          _macroRow(
            context,
            'Karbonhidrat',
            a.averageCarbsLoggedDays,
            a.carbsTarget,
          ),
          _macroRow(context, 'Yağ', a.averageFatLoggedDays, a.fatTarget),
        ],
      ),
    ),
  );

  Widget _macroRow(
    BuildContext context,
    String label,
    double? value,
    int target,
  ) {
    final fraction = value == null || target <= 0
        ? 0.0
        : (value / target).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(
                value == null
                    ? 'Veri yok · hedef $target g'
                    : '${value.toStringAsFixed(1)} / $target g',
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(value: fraction),
        ],
      ),
    );
  }

  Widget _waterCard(BuildContext context, AnalyticsSnapshot a) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Su tüketimi', style: Theme.of(context).textTheme.titleLarge),
          Text(
            'Kayıtlı günlerin ortalaması: '
            '${_format(a.averageWaterLoggedDays, 'ml')}',
          ),
          Text(
            'Görsel referans: ${a.waterReferenceMl} ml (kişisel reçete değil)',
          ),
          const SizedBox(height: 12),
          if (a.loggedWaterDays == 0)
            const Text('Henüz su kaydı yok; grafik oluşturulamıyor.')
          else
            _calendarBars(
              a.days,
              (d) => d.hasWater ? d.waterMl.toDouble() : null,
              reference: a.waterReferenceMl.toDouble(),
              color: Theme.of(context).colorScheme.tertiary,
              label: 'Su',
            ),
        ],
      ),
    ),
  );

  Widget _calendarBars(
    List<AnalyticsDay> days,
    double? Function(AnalyticsDay) extract, {
    required double reference,
    required Color color,
    required String label,
  }) {
    final observed = days.map(extract).whereType<double>().toList();
    final top = math.max(
      1.0,
      math.max(
            reference,
            observed.fold<double>(
              0,
              (current, value) => math.max(current, value),
            ),
          ) *
          1.15,
    );
    final width = math.max(
      290.0,
      days.length * (_periodDays == 90 ? 12.0 : 22.0),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            height: 190,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: top,
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                barTouchData: BarTouchData(enabled: true),
                barGroups: [
                  for (var i = 0; i < days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: extract(days[i]) ?? 0,
                          width: _periodDays == 90 ? 6 : 12,
                          color: extract(days[i]) == null
                              ? color.withValues(alpha: .13)
                              : color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                ],
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: reference,
                      color: color.withValues(alpha: .7),
                      strokeWidth: 1,
                      dashArray: [5, 4],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Soldan sağa: ${_date(days.first.day)} – ${_date(days.last.day)}. '
          'Soluk sütun = kayıt yok. Kesikli çizgi = $label referansı.',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _recentDaysCard(BuildContext context, AnalyticsSnapshot a) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son 7 günün kayıt ayrıntıları',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final day in a.days.reversed.take(7))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_date(day.day)),
              subtitle: Text(
                day.hasMeals
                    ? '${day.mealCount} öğün · ${day.caloriesKcal} kcal'
                    : 'Öğün kaydı yok',
              ),
              trailing: Text(
                day.hasWater ? '${day.waterMl} ml' : 'Su kaydı yok',
              ),
            ),
        ],
      ),
    ),
  );

  Widget _weightCard(
    BuildContext context,
    AnalyticsSnapshot a,
    AsyncValue<int> pending,
  ) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Kilo geçmişi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FilledButton.tonalIcon(
                key: const Key('analytics-add-weight'),
                onPressed: _busy ? null : _addWeight,
                icon: const Icon(Icons.add),
                label: const Text('Ölçüm ekle'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Son ölçüm: ${a.lastWeightKg == null ? 'Veri yok' : '${a.lastWeightKg!.toStringAsFixed(1)} kg'}',
          ),
          Text(
            'Dönem içi değişim: ${a.weightChangeKg == null ? 'En az 2 ölçüm gerekli' : '${a.weightChangeKg! >= 0 ? '+' : ''}${a.weightChangeKg!.toStringAsFixed(1)} kg'}',
          ),
          if (widget.profile.targetWeightKg != null)
            Text(
              'Profildeki hedef: ${widget.profile.targetWeightKg!.toStringAsFixed(1)} kg',
            ),
          const SizedBox(height: 8),
          if (a.weightEntries.isEmpty)
            const Text('Seçilen dönemde kilo ölçümü yok.')
          else ...[
            if (a.weightEntries.length > 1) ...[
              SizedBox(height: 190, child: _weightLine(a.weightEntries)),
              const Text(
                'Kilo eğrisi: yatay eksen ölçümler arasındaki geçen süredir.',
                style: TextStyle(fontSize: 12),
              ),
            ],
            const SizedBox(height: 8),
            for (final entry in a.weightEntries.reversed.take(5))
              ListTile(
                dense: true,
                title: Text('${entry.weightKg.toStringAsFixed(1)} kg'),
                subtitle: Text(_date(entry.recordedAt.toLocal())),
                trailing: IconButton(
                  tooltip: 'Kilo ölçümünü sil',
                  onPressed: _busy ? null : () => _deleteWeight(entry),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  pending.when(
                    data: (n) => n == 0
                        ? 'Bekleyen kilo kaydı yok.'
                        : '$n kilo kaydı buluta gönderilmeyi bekliyor.',
                    loading: () => 'Eşitleme durumu okunuyor...',
                    error: (_, _) => 'Eşitleme durumu alınamadı.',
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Kilo kayıtlarını eşitle',
                onPressed: () => _syncWeight(),
                icon: const Icon(Icons.sync),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _weightLine(List<WeightEntry> measurements) {
    final low = measurements.map((e) => e.weightKg).reduce(math.min);
    final high = measurements.map((e) => e.weightKg).reduce(math.max);
    final firstTime = measurements.first.recordedAt;
    double elapsedDays(WeightEntry entry) =>
        entry.recordedAt.difference(firstTime).inMilliseconds / 86400000.0;
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(1.0, elapsedDays(measurements.last)),
        minY: math.max(0, low - 2),
        maxY: high + 2,
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < measurements.length; i++)
                FlSpot(elapsedDays(measurements[i]), measurements[i].weightKg),
            ],
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isCurved: false,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  static String _format(double? value, String unit) =>
      value == null ? 'Veri yok' : '${value.round()} $unit';
  static String _date(DateTime d) => '${d.day}.${d.month}.${d.year}';
}

/// Dialog owns the controller until its route is fully disposed.
class _WeightEntryDialog extends StatefulWidget {
  const _WeightEntryDialog();

  @override
  State<_WeightEntryDialog> createState() => _WeightEntryDialogState();
}

class _WeightEntryDialogState extends State<_WeightEntryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    if (value == null || !value.isFinite || value < 10 || value > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('10–500 kg arası geçerli bir sayı gir.')),
      );
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Yeni kilo ölçümü'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'İstediğin zaman ölçüm ekleyebilirsin. Kilo değişimleri '
          'günlük dalgalanmalardan etkilenebilir.',
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('analytics-weight-field'),
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Kilo (kg)',
            hintText: 'Örn. 72,5',
          ),
          onSubmitted: (_) => _submit(),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      FilledButton(
        key: const Key('analytics-save-weight'),
        onPressed: _submit,
        child: const Text('Ölçümü kaydet'),
      ),
    ],
  );
}
