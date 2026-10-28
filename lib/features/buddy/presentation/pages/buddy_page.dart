import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/buddy/data/services/buddy_cloud_service.dart';
import 'package:nutri_buddy/features/buddy/domain/usecases/buddy_progress.dart';
import 'package:nutri_buddy/features/buddy/presentation/providers/buddy_providers.dart';
import 'package:nutri_buddy/features/buddy/presentation/widgets/buddy_mascot.dart';
import 'package:nutri_buddy/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_sync_providers.dart';

class BuddyPage extends ConsumerStatefulWidget {
  const BuddyPage({required this.userId, super.key});
  final String userId;

  @override
  ConsumerState<BuddyPage> createState() => _BuddyPageState();
}

class _BuddyPageState extends ConsumerState<BuddyPage> {
  bool _busy = false;
  String? _message;
  int _celebrationId = 0;
  int? _lastXp;
  Set<String> _equippedKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_refresh());
    });
  }

  Future<void> _refresh() async {
    if (_busy) return;
    final cloud = ref.read(buddyCloudServiceProvider);
    if (cloud == null) {
      setState(
        () => _message = 'Bulut bağlantısı yok. Son kaydedilen Buddy bilgileri gösteriliyor.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      // Sync first so the server rewards only confirmed meal/water entries.
      try {
        final waterSync = ref.read(waterCloudSyncProvider);
        if (waterSync != null) {
          await waterSync
              .syncPending(widget.userId)
              .timeout(const Duration(seconds: 8));
        }
      } catch (_) {
        /* Pending changes are retained locally. */
      }
      try {
        final mealSync = ref.read(mealCloudSyncProvider);
        if (mealSync != null) {
          await mealSync
              .syncPending(widget.userId)
              .timeout(const Duration(seconds: 8));
        }
      } catch (_) {
        /* Pending changes are retained locally. */
      }
      final pet = await cloud
          .refresh(widget.userId)
          .timeout(const Duration(seconds: 12));
      if (!mounted) return;
      if (_lastXp != null && pet.xp > _lastXp!) _celebrationId++;
      _lastXp = pet.xp;
      await _loadEquipped(cloud);
      if (!mounted) return;
      setState(() => _message = 'Buddy ilerlemesi güncellendi.');
    } catch (_) {
      if (mounted) {
        setState(
          () => _message = 'Sunucuya ulaşılamadı. Yerel Buddy kaydı korunuyor.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _loadEquipped(BuddyCloudService cloud) async {
    final ids = await cloud.equippedItemIds(widget.userId);
    final catalog = await cloud.catalog(widget.userId);
    if (!mounted) return;
    setState(
      () => _equippedKeys = catalog
          .where((item) => ids.contains(item['id']))
          .map((item) => item['asset_key'] as String)
          .toSet(),
    );
  }

  Future<void> _shop() async {
    final cloud = ref.read(buddyCloudServiceProvider);
    if (cloud == null) {
      setState(() => _message = 'Mağaza için internet bağlantısı gerekiyor.');
      return;
    }
    try {
      final catalog = await cloud.catalog(widget.userId);
      var owned = await cloud.ownedItemIds(widget.userId);
      var equipped = await cloud.equippedItemIds(widget.userId);
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (modalContext) => StatefulBuilder(
          builder: (context, setModalState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Buddy mağazası',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Altın yalnızca eşitlenmiş öğün ve su kayıtlarından kazanılır.',
                  ),
                  const SizedBox(height: 8),
                  for (final item in catalog)
                    ListTile(
                      title: Text(item['name'] as String),
                      subtitle: Text(
                        '${item['gold_price']} altın · ${item['slot']}',
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: equipped.contains(item['id'])
                            ? null
                            : () async {
                                try {
                                  final id = item['id'] as String;
                                  if (!owned.contains(id)) {
                                    await cloud.purchase(widget.userId, id);
                                    owned = await cloud.ownedItemIds(
                                      widget.userId,
                                    );
                                  } else {
                                    await cloud.equip(widget.userId, id);
                                    equipped = await cloud.equippedItemIds(
                                      widget.userId,
                                    );
                                    await _loadEquipped(cloud);
                                  }
                                  if (modalContext.mounted) {
                                    setModalState(() {});
                                  }
                                } catch (_) {
                                  if (modalContext.mounted) {
                                    ScaffoldMessenger.of(modalContext)
                                        .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'İşlem tamamlanamadı. Altın veya bağlantı durumunu kontrol et.',
                                            ),
                                          ),
                                        );
                                  }
                                }
                              },
                        child: Text(
                          equipped.contains(item['id'])
                              ? 'Kullanılıyor'
                              : owned.contains(item['id'])
                              ? 'Kullan'
                              : 'Satın al',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      if (mounted) await _refresh();
    } catch (_) {
      if (mounted) {
        setState(() => _message = 'Mağaza yüklenemedi. İnterneti kontrol et.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(buddyPetProvider(widget.userId));
    final today = DateTime.now();
    final localDay = DateTime(today.year, today.month, today.day);
    final water = ref.watch(waterDayProvider(widget.userId, localDay));
    final meals = ref.watch(dailyNutritionProvider(widget.userId, localDay));
    final waterMl = water.value?.consumedMl ?? 0;
    final mealCount = meals.value?.mealCount ?? 0;
    final mood = BuddyProgress.moodForDay(meals: mealCount, waterMl: waterMl);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddy arkadaşım'),
        actions: [
          IconButton(
            key: const Key('buddy-sync'),
            tooltip: 'Ödülleri eşitle',
            onPressed: _busy ? null : _refresh,
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      'Her küçük adım değerli 🌱',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _celebrationId++),
                      child: BuddyMascot(
                        mood: mood,
                        celebrationId: _celebrationId,
                        equippedAssetKeys: _equippedKeys,
                      ),
                    ),
                    Text(
                      mood == 'energetic'
                          ? 'Bugün su ve öğün kaydın var!'
                          : mood == 'happy'
                          ? 'Bugün bir ilerleme kaydın var!'
                          : 'Yeni bir güne birlikte başlayalım.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Buddy’ye dokun, bir selam versin.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            pet.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Text('Buddy kayıtları okunamadı.'),
              data: (value) {
                final xp = value?.xp ?? 0;
                final level = BuddyProgress.levelForXp(xp);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seviye $level',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: BuddyProgress.levelFraction(xp),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$xp XP · Sonraki seviye: ${BuddyProgress.nextLevelXp(level)} XP',
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.toll_outlined),
                              label: Text('${value?.gold ?? 0} altın'),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.local_fire_department_outlined,
                              ),
                              label: Text(
                                '${value?.streakDays ?? 0} günlük seri',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ödül kuralları',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Eşitlenmiş her öğün: +20 XP ve +4 altın (günde en çok 3).',
                    ),
                    const Text(
                      '100–1000 ml arasındaki her su kaydı: +5 XP ve +1 altın (günde en çok 8).',
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tekrar eşitlemek yeni puan vermez. Ödüller sağlık hedefi veya su içme önerisi değildir.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('buddy-shop'),
              onPressed: _busy ? null : _shop,
              icon: const Icon(Icons.storefront_outlined),
              label: const Text('Buddy mağazasını aç'),
            ),
            const SizedBox(height: 8),
            if (_busy) const Center(child: CircularProgressIndicator()),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_message!, textAlign: TextAlign.center),
              ),
            Text(
              'Çevrimdışıyken son puanın gösterilir; yeni XP/altın yalnızca sunucu onayıyla kazanılır.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
