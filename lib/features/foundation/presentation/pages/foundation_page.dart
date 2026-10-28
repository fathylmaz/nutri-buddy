import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/database/database_ready_provider.dart';
import 'package:nutri_buddy/features/foundation/presentation/providers/foundation_provider.dart';

class FoundationPage extends ConsumerWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(foundationStatusProvider);
    final isarReady = ref.watch(databaseReadyProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('NutriBuddy')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Icon(Icons.storage_rounded, size: 68, color: scheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Veri mimarisi hazır',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Clean Architecture + Isar + Supabase',
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
                          'Kurulum durumu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aşama ${status.currentStage} / ${status.totalStages}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isarReady
                              ? 'Isar: açık (8 koleksiyon)'
                              : 'Isar: bağlantı yok',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          status.cloudConfigured
                              ? 'Supabase: istemci yapılandırıldı (Auth henüz yok)'
                              : 'Supabase: isteğe bağlı; çevrimdışı mod etkin',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'RLS SQL: Supabase projesine ayrıca uygulanmalı.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Şemalar ve repository sözleşmeleri hazır. '
                  'Gerçek zamanlı eşitleme, giriş ve onboarding henüz uygulanmadı.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
