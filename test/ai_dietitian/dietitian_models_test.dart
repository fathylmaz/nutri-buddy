import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/ai_dietitian/domain/dietitian_models.dart';

void main() {
  test('only day-level numeric totals are serialized', () {
    const ctx = DietitianDailyContext(
      date: '2026-10-26',
      caloriesKcal: 1450,
      proteinG: 72,
      carbsG: 180,
      fatG: 42,
      waterMl: 950,
      mealCount: 3,
      targetCaloriesKcal: 2000,
    );
    expect(ctx.toJson(), containsPair('calories_kcal', 1450));
    expect(ctx.toJson(), containsPair('water_ml', 950));
    expect(ctx.toJson().containsKey('allergies'), false);
    expect(ctx.toJson().containsKey('chronic_conditions'), false);
    expect(ctx.toJson().containsKey('user_id'), false);
  });

  test('only https references are accepted', () {
    final reply = DietitianReply.fromJson({
      'conversation_id': 'abc',
      'answer': 'Çeşitli sebzeler tüketmek genel beslenmeyi destekler.',
      'sources': [
        {
          'key': 'who-balanced',
          'title': 'WHO — Healthy diet',
          'url':
              'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
        },
      ],
    });
    expect(reply.sources.single.key, 'who-balanced');
    expect(
      () => DietitianSource.fromJson({
        'key': 'fake',
        'title': 'Fake',
        'url': 'javascript:alert(1)',
      }),
      throwsFormatException,
    );
  });

  test('messages tolerate empty source lists', () {
    final message = DietitianMessage.fromJson({
      'role': 'user',
      'content': 'Merhaba',
      'sources': [],
    });
    expect(message.role, 'user');
    expect(message.sources, isEmpty);
  });
}
