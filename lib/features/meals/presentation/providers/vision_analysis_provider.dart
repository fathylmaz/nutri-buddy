import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/features/meals/data/repositories/supabase_vision_analysis_repository.dart';
import 'package:nutri_buddy/features/meals/domain/repositories/vision_analysis_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final visionAnalysisRepositoryProvider = Provider<VisionAnalysisRepository?>((
  ref,
) {
  if (!AppConfig.cloudConfigured) {
    return null;
  }
  return SupabaseVisionAnalysisRepository(Supabase.instance.client);
});
