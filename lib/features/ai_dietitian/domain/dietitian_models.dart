import 'dart:convert';

/// Only numeric, non-identifying day-level totals may optionally be shared.
/// Names, diagnoses, allergies and exact meal descriptions are never added.
class DietitianDailyContext {
  const DietitianDailyContext({
    required this.date,
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterMl,
    required this.mealCount,
    required this.targetCaloriesKcal,
  });

  final String date;
  final int caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int waterMl;
  final int mealCount;
  final int targetCaloriesKcal;

  Map<String, Object> toJson() => {
    'date': date,
    'calories_kcal': caloriesKcal,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'water_ml': waterMl,
    'meal_count': mealCount,
    'target_calories_kcal': targetCaloriesKcal,
  };
}

class DietitianSource {
  const DietitianSource({
    required this.key,
    required this.title,
    required this.url,
  });

  final String key;
  final String title;
  final String url;

  factory DietitianSource.fromJson(Map<String, dynamic> value) {
    final key = value['key'];
    final title = value['title'];
    final url = value['url'];
    if (key is! String ||
        title is! String ||
        url is! String ||
        Uri.tryParse(url)?.scheme != 'https') {
      throw const FormatException('Kaynak bağlantısı geçersiz.');
    }
    return DietitianSource(key: key, title: title, url: url);
  }
}

class DietitianConversation {
  const DietitianConversation({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;

  factory DietitianConversation.fromJson(Map<String, dynamic> value) =>
      DietitianConversation(
        id: value['id'] as String,
        title: value['title'] as String,
        createdAt: DateTime.parse(value['created_at'] as String),
      );
}

class DietitianMessage {
  const DietitianMessage({
    required this.role,
    required this.content,
    required this.sources,
  });

  final String role;
  final String content;
  final List<DietitianSource> sources;

  factory DietitianMessage.fromJson(Map<String, dynamic> value) {
    dynamic rawSources = value['sources'];
    if (rawSources is String) {
      rawSources = jsonDecode(rawSources);
    }
    return DietitianMessage(
      role: value['role'] as String,
      content: value['content'] as String,
      sources: rawSources is List
          ? rawSources
                .whereType<Map>()
                .map(
                  (s) => DietitianSource.fromJson(Map<String, dynamic>.from(s)),
                )
                .toList(growable: false)
          : const <DietitianSource>[],
    );
  }
}

class DietitianReply {
  const DietitianReply({
    required this.conversationId,
    required this.answer,
    required this.sources,
  });

  final String conversationId;
  final String answer;
  final List<DietitianSource> sources;

  factory DietitianReply.fromJson(Map<String, dynamic> value) {
    final sources = value['sources'];
    if (value['conversation_id'] is! String ||
        value['answer'] is! String ||
        sources is! List) {
      throw const FormatException('AI yanıt biçimi geçersiz.');
    }
    return DietitianReply(
      conversationId: value['conversation_id'] as String,
      answer: value['answer'] as String,
      sources: sources
          .whereType<Map>()
          .map((s) => DietitianSource.fromJson(Map<String, dynamic>.from(s)))
          .toList(growable: false),
    );
  }
}

abstract interface class DietitianRepository {
  Future<List<DietitianConversation>> conversations();
  Future<List<DietitianMessage>> messages(String conversationId);
  Future<void> deleteConversation(String conversationId);
  Future<DietitianReply> ask({
    required String conversationId,
    required String question,
    required bool consent,
    DietitianDailyContext? dailyContext,
  });
}
