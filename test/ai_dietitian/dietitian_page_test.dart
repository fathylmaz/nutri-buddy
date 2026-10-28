import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/ai_dietitian/domain/dietitian_models.dart';
import 'package:nutri_buddy/features/ai_dietitian/presentation/dietitian_page.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

class _FakeDietitian implements DietitianRepository {
  int calls = 0;
  bool? lastConsent;
  DietitianDailyContext? lastDaily;

  @override
  Future<DietitianReply> ask({
    required String conversationId,
    required String question,
    required bool consent,
    DietitianDailyContext? dailyContext,
  }) async {
    calls++;
    lastConsent = consent;
    lastDaily = dailyContext;
    return DietitianReply(
      conversationId: conversationId,
      answer: 'Çeşitli sebze ve baklagiller denenebilir.',
      sources: const [
        DietitianSource(
          key: 'who-balanced',
          title: 'WHO — Healthy diet',
          url: 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
        ),
      ],
    );
  }

  @override
  Future<List<DietitianConversation>> conversations() async => [];
  @override
  Future<List<DietitianMessage>> messages(String conversationId) async => [];
  @override
  Future<void> deleteConversation(String conversationId) async {}
}

void main() {
  testWidgets('explicit consent gates sends; sources are displayed', (
    tester,
  ) async {
    final fake = _FakeDietitian();
    final profile = UserProfile(
      id: 'test-user',
      updatedAt: DateTime.utc(2026, 10, 26),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DietitianPage(
            userId: 'test-user',
            profile: profile,
            repository: fake,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final send = find.byKey(const Key('dietitian-send'));
    expect(tester.widget<IconButton>(send).onPressed, isNull);
    await tester.enterText(
      find.byKey(const Key('dietitian-question')),
      'Lifli yiyecekler nelerdir?',
    );
    expect(fake.calls, 0);
    await tester.tap(find.byKey(const Key('dietitian-consent')));
    await tester.pumpAndSettle();
    expect(tester.widget<IconButton>(send).onPressed, isNotNull);
    await tester.tap(send);
    await tester.pumpAndSettle();
    expect(fake.calls, 1);
    expect(fake.lastConsent, isTrue);
    expect(fake.lastDaily, isNull);
    expect(
      find.text('Çeşitli sebze ve baklagiller denenebilir.'),
      findsOneWidget,
    );
    expect(find.text('WHO — Healthy diet'), findsOneWidget);
  });
}
