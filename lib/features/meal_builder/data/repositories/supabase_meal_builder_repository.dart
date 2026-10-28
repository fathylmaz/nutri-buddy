import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';
import 'package:nutri_buddy/features/meal_builder/domain/repositories/meal_builder_repository.dart';
import 'package:nutri_buddy/features/meal_builder/domain/usecases/recipe_allergen_guard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseMealBuilderRepository implements MealBuilderRepository {
  const SupabaseMealBuilderRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<MealRecipe>> generate(MealBuilderRequest request) async {
    if (_client.auth.currentUser == null ||
        _client.auth.currentSession == null) {
      throw StateError('Tarif önerisi için tekrar giriş yapmalısın.');
    }
    if (request.count < 1 || request.count > 3) {
      throw ArgumentError.value(request.count, 'count');
    }
    final response = await _client.functions
        .invoke('build-meals', body: request.toJson())
        .timeout(const Duration(seconds: 50));
    if (response.status != 200 || response.data is! Map) {
      throw StateError(
        'Tarif servisi yanıt vermedi (HTTP ${response.status}). '
        'Supabase build-meals Invocations/Logs bölümünü kontrol et.',
      );
    }
    final body = Map<String, dynamic>.from(response.data as Map);
    final raw = body['recipes'];
    if (raw is! List || raw.isEmpty || raw.length > request.count) {
      throw const FormatException('AI beklenmeyen tarif listesi gönderdi.');
    }
    final recipes = raw
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Tarif biçimi geçersiz.');
          }
          final recipe = MealRecipe.fromJson(Map<String, dynamic>.from(item));
          final matched = RecipeAllergenGuard.firstExplicitMatch(
            recipe,
            request.exclusions,
          );
          if (matched != null) {
            throw FormatException(
              'Tarif dışladığın bir malzemeyi içeriyor: $matched. '
              'Tarifleri kontrol etmeden tüketme.',
            );
          }
          return recipe;
        })
        .toList(growable: false);
    return recipes;
  }
}
