import 'dart:typed_data';

import 'package:nutri_buddy/features/meals/domain/entities/vision_meal_analysis.dart';

abstract interface class VisionAnalysisRepository {
  /// Only a signed-in, explicitly consenting user may invoke this service.
  /// Images are transferred for analysis but never persisted by this client.
  Future<VisionMealAnalysis> analyze({
    required Uint8List imageBytes,
    required String mimeType,
  });
}
