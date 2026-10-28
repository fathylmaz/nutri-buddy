import 'dart:convert';
import 'dart:typed_data';

import 'package:nutri_buddy/features/meals/data/mappers/vision_meal_analysis_mapper.dart';
import 'package:nutri_buddy/features/meals/domain/entities/vision_meal_analysis.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/vision_analysis_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseVisionAnalysisRepository
    implements VisionAnalysisRepository {
  const SupabaseVisionAnalysisRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<VisionMealAnalysis> analyze({
    required Uint8List imageBytes,
    required String mimeType,
  }) async {
    if (_client.auth.currentUser == null ||
        _client.auth.currentSession == null) {
      throw StateError('Fotoğraf analizi için oturum açmalısın.');
    }
    if (imageBytes.isEmpty || imageBytes.length > 5 * 1024 * 1024) {
      throw const FormatException('Fotoğraf 5 MB sınırını aşmamalı.');
    }
    if (!{'image/jpeg', 'image/png', 'image/webp'}.contains(mimeType)) {
      throw const FormatException('Yalnızca JPEG, PNG ve WEBP desteklenir.');
    }
    final result = await _client.functions
        .invoke(
          'analyze-meal',
          body: {
            'mime_type': mimeType,
            'image_base64': base64Encode(imageBytes),
          },
        )
        .timeout(const Duration(seconds: 45));
    if (result.status != 200 || result.data is! Map) {
      throw const FormatException('AI analizi tamamlanamadı. Yeniden dene.');
    }
    final payload = Map<String, dynamic>.from(result.data as Map);
    final raw = payload['analysis'];
    if (raw is! Map) {
      throw const FormatException('AI beklenen JSON verisini göndermedi.');
    }
    return VisionMealAnalysisMapper.fromJson(Map<String, dynamic>.from(raw));
  }
}
