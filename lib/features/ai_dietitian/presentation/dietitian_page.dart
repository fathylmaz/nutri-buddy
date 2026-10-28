import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/ai_dietitian/data/supabase_dietitian_repository.dart';
import 'package:nutri_buddy/features/ai_dietitian/domain/dietitian_models.dart';
import 'package:nutri_buddy/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DietitianPage extends ConsumerStatefulWidget {
  const DietitianPage({
    required this.userId,
    required this.profile,
    this.repository,
    super.key,
  });

  final String userId;
  final UserProfile profile;
  final DietitianRepository? repository;

  @override
  ConsumerState<DietitianPage> createState() => _DietitianPageState();
}

class _DietitianPageState extends ConsumerState<DietitianPage> {
  final TextEditingController _question = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<DietitianMessage> _messages = [];
  String? _conversationId;
  String? _notice;
  bool _consent = false;
  bool _shareDaily = false;
  bool _sending = false;

  DietitianRepository get _repository =>
      widget.repository ??
      SupabaseDietitianRepository(Supabase.instance.client);

  @override
  void dispose() {
    _question.dispose();
    _scroll.dispose();
    super.dispose();
  }

  static String _uuid() {
    final generator = Random.secure();
    final values = List<int>.generate(16, (_) => generator.nextInt(256));
    values[6] = (values[6] & 15) | 64;
    values[8] = (values[8] & 63) | 128;
    final hex = values.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  void _newConversation() {
    setState(() {
      _conversationId = null;
      _messages.clear();
      _notice = null;
    });
  }

  Future<void> _loadConversation(String id) async {
    setState(() => _sending = true);
    try {
      final result = await _repository.messages(id);
      if (!mounted) {
        return;
      }
      setState(() {
        _conversationId = id;
        _messages
          ..clear()
          ..addAll(result);
        _notice = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _notice = 'Sohbet geçmişi okunamadı.');
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _showHistory() async {
    try {
      final conversations = await _repository.conversations();
      if (!mounted) {
        return;
      }
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (sheetContext) => SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * .62,
            child: Column(
              children: [
                const ListTile(title: Text('Sohbet geçmişi')),
                Expanded(
                  child: conversations.isEmpty
                      ? const Center(
                          child: Text('Henüz kaydedilmiş sohbet yok.'),
                        )
                      : ListView.builder(
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];
                            return ListTile(
                              title: Text(conversation.title, maxLines: 2),
                              onTap: () {
                                Navigator.pop(sheetContext);
                                _loadConversation(conversation.id);
                              },
                              trailing: IconButton(
                                tooltip: 'Sohbeti sil',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  final delete = await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Text('Sohbeti sil?'),
                                      content: const Text(
                                        'Bu işlem sohbeti ve kayıtlı mesajları buluttan siler.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            false,
                                          ),
                                          child: const Text('Vazgeç'),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            true,
                                          ),
                                          child: const Text('Sil'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (delete != true) {
                                    return;
                                  }
                                  try {
                                    await _repository.deleteConversation(
                                      conversation.id,
                                    );
                                    if (!mounted) {
                                      return;
                                    }
                                    if (_conversationId == conversation.id) {
                                      _newConversation();
                                    }
                                    if (sheetContext.mounted) {
                                      Navigator.pop(sheetContext);
                                    }
                                    setState(() => _notice = 'Sohbet silindi.');
                                  } catch (_) {
                                    if (mounted) {
                                      setState(
                                        () => _notice = 'Sohbet silinemedi.',
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _notice = 'Sohbet listesi alınamadı.');
      }
    }
  }

  Future<DietitianDailyContext> _dailyContext() async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final nutrition = await ref
        .read(dailyNutritionProvider(widget.userId, day).future)
        .timeout(const Duration(seconds: 8));
    final water = await ref
        .read(waterDayProvider(widget.userId, day).future)
        .timeout(const Duration(seconds: 8));
    final targets = NutritionCalculator.calculate(widget.profile);
    String two(int value) => value.toString().padLeft(2, '0');
    return DietitianDailyContext(
      date: '${now.year}-${two(now.month)}-${two(now.day)}',
      caloriesKcal: nutrition.caloriesKcal,
      proteinG: nutrition.proteinG,
      carbsG: nutrition.carbsG,
      fatG: nutrition.fatG,
      waterMl: water.consumedMl,
      mealCount: nutrition.mealCount,
      targetCaloriesKcal: targets.dailyCalories,
    );
  }

  Future<void> _send() async {
    if (_sending || !_consent) {
      return;
    }
    final question = _question.text.trim();
    if (question.length < 3 || question.length > 900) {
      setState(() => _notice = 'Sorun 3–900 karakter olmalı.');
      return;
    }
    setState(() {
      _sending = true;
      _notice = null;
    });
    try {
      final context = _shareDaily ? await _dailyContext() : null;
      final id = _conversationId ?? _uuid();
      final reply = await _repository.ask(
        conversationId: id,
        question: question,
        consent: true,
        dailyContext: context,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _conversationId = reply.conversationId;
        _messages.add(
          DietitianMessage(role: 'user', content: question, sources: const []),
        );
        _messages.add(
          DietitianMessage(
            role: 'assistant',
            content: reply.answer,
            sources: reply.sources,
          ),
        );
        _question.clear();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (error) {
      if (mounted) {
        setState(
          () => _notice = error is FormatException
              ? 'Günlük hedef veya soru verileri geçersiz. Paylaşım ayarını kontrol et.'
              : 'AI yanıt alınamadı. Bağlantıyı, günlük kotayı ve dietitian-chat kayıtlarını kontrol et.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Beslenme Asistanı'),
        actions: [
          IconButton(
            key: const Key('dietitian-new-chat'),
            tooltip: 'Yeni sohbet',
            onPressed: _sending ? null : _newConversation,
            icon: const Icon(Icons.add_comment_outlined),
          ),
          IconButton(
            key: const Key('dietitian-history'),
            tooltip: 'Sohbet geçmişi',
            onPressed: _sending ? null : _showHistory,
            icon: const Icon(Icons.history_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Material(
                  color: scheme.surfaceContainerLow,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Genel beslenme bilgisi sunar; teşhis, tedavi veya '
                      'kişiye özel tıbbi diyet yerine geçmez. Acil durumda 112’yi ara. '
                      'Yanıtlar hatalı olabilir; kaynak bağlantılarını doğrula.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Merhaba! 🌱 Dengeli öğünler, lif ve genel beslenme hakkında '
                              'soru sorabilirsin. Yanıtta kullanılan kaynakları göstereceğim.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scroll,
                          key: const Key('dietitian-messages'),
                          padding: const EdgeInsets.all(12),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            final user = message.role == 'user';
                            return Align(
                              alignment: user
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 580,
                                ),
                                child: Card(
                                  color: user ? scheme.primaryContainer : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectableText(message.content),
                                        if (!user) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Kullanılan kaynaklar',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                          if (message.sources.isEmpty)
                                            const Text(
                                              'Bu yanıtta doğrulanmış kaynak belirtilmedi.',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          for (final source in message.sources)
                                            TextButton.icon(
                                              icon: const Icon(
                                                Icons.open_in_new,
                                                size: 15,
                                              ),
                                              label: Text(
                                                source.title,
                                                maxLines: 2,
                                              ),
                                              onPressed: () async {
                                                final url = Uri.tryParse(
                                                  source.url,
                                                );
                                                if (url != null &&
                                                    url.scheme == 'https') {
                                                  await launchUrl(
                                                    url,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  );
                                                }
                                              },
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (_notice != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                    child: Text(
                      _notice!,
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                if (_sending) const LinearProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        key: const Key('dietitian-consent'),
                        value: _consent,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text(
                          'Sorumu Gemini’ye iletmeyi ve sohbeti Supabase’de saklamayı onaylıyorum.',
                          style: TextStyle(fontSize: 12),
                        ),
                        onChanged: _sending
                            ? null
                            : (value) =>
                                  setState(() => _consent = value ?? false),
                      ),
                      CheckboxListTile(
                        key: const Key('dietitian-share-day'),
                        value: _shareDaily,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text(
                          'Bugünün sayısal kalori, makro ve su özetini de paylaş (isteğe bağlı).',
                          style: TextStyle(fontSize: 12),
                        ),
                        onChanged: _sending
                            ? null
                            : (value) =>
                                  setState(() => _shareDaily = value ?? false),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('dietitian-question'),
                              controller: _question,
                              minLines: 1,
                              maxLines: 3,
                              maxLength: 900,
                              enabled: !_sending,
                              decoration: const InputDecoration(
                                hintText: 'Örnek: Lifli besinler hangileri?',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            key: const Key('dietitian-send'),
                            tooltip: 'Soru gönder',
                            icon: const Icon(Icons.send_rounded),
                            onPressed: _sending || !_consent ? null : _send,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
