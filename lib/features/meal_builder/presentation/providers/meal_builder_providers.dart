import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/features/meal_builder/data/repositories/supabase_meal_builder_repository.dart';
import 'package:nutri_buddy/features/meal_builder/domain/repositories/meal_builder_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Deliberately a regular Provider: no additional generated .g.dart files.
final mealBuilderRepositoryProvider = Provider<MealBuilderRepository?>((ref) {
  if (!AppConfig.cloudConfigured) {
    return null;
  }
  return SupabaseMealBuilderRepository(Supabase.instance.client);
});
