import 'package:nutri_buddy/features/onboarding/data/repositories/isar_user_repository.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/repositories/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Local-first profile persistence. Cloud sync is an immediate best effort;
/// manual retry is provided; background replay remains out of scope.
final class OfflineFirstProfileService implements ProfileService {
  OfflineFirstProfileService(this._local, this._client);
  final IsarUserRepository _local;
  final SupabaseClient _client;

  void _assertOwner(String id) {
    if (_client.auth.currentUser?.id != id) {
      throw StateError('Oturum ile profil sahibi eşleşmiyor.');
    }
  }

  @override
  Future<UserProfile?> load(String userId) async {
    _assertOwner(userId);
    final cached = await _local.getById(userId);
    if (await _local.hasPending(userId)) return cached;
    try {
      final row = await _client
          .from('users')
          .select(
            'id,display_name,sex_for_calculation,birth_date,height_cm,weight_kg,'
            'target_weight_kg,goal,activity_level,allergies,chronic_conditions,timezone,updated_at',
          )
          .eq('id', userId)
          .maybeSingle();
      if (row == null) return cached;
      final remote = _fromJson(row);
      await _local.cacheFromServer(remote);
      return remote;
    } catch (_) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<ProfileSaveResult> save(UserProfile profile) async {
    _assertOwner(profile.id);
    await _local.saveLocally(profile);
    try {
      await _updateCloud(profile);
      await _local.markSynced(profile);
      return ProfileSaveResult.synchronized;
    } catch (_) {
      return ProfileSaveResult.savedLocallyOnly;
    }
  }

  @override
  Future<bool> synchronizePending(String userId) async {
    _assertOwner(userId);
    if (!await _local.hasPending(userId)) return true;
    final profile = await _local.getById(userId);
    if (profile == null) return false;
    try {
      await _updateCloud(profile);
      await _local.markSynced(profile);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> hasPending(String userId) => _local.hasPending(userId);

  Future<void> _updateCloud(UserProfile profile) async {
    _assertOwner(profile.id);
    // Stage 2 auth trigger already inserts the row. Upsert would require INSERT
    // grants; explicitly update only the authenticated user's existing row.
    await _client
        .from('users')
        .update({
          'display_name': profile.displayName,
          'sex_for_calculation': profile.sexForCalculation,
          'birth_date': profile.birthDate == null
              ? null
              : _date(profile.birthDate!),
          'height_cm': profile.heightCm,
          'weight_kg': profile.weightKg,
          'target_weight_kg': profile.targetWeightKg,
          'goal': profile.goal,
          'activity_level': profile.activityLevel,
          'allergies': profile.allergies,
          'chronic_conditions': profile.chronicConditions,
          'timezone': profile.timezone,
        })
        .eq('id', profile.id)
        .select('id')
        .single();
  }

  static String _date(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static double? _num(Object? value) =>
      value == null ? null : (value as num).toDouble();

  static UserProfile _fromJson(Map<String, dynamic> row) => UserProfile(
    id: row['id'] as String,
    displayName: row['display_name'] as String?,
    sexForCalculation: row['sex_for_calculation'] as String?,
    birthDate: row['birth_date'] == null
        ? null
        : DateTime.parse(row['birth_date'] as String),
    heightCm: _num(row['height_cm']),
    weightKg: _num(row['weight_kg']),
    targetWeightKg: _num(row['target_weight_kg']),
    goal: row['goal'] as String?,
    activityLevel: row['activity_level'] as String?,
    allergies: List<String>.from(
      row['allergies'] as List<dynamic>? ?? const [],
    ),
    chronicConditions: List<String>.from(
      row['chronic_conditions'] as List<dynamic>? ?? const [],
    ),
    timezone: row['timezone'] as String? ?? 'UTC',
    updatedAt: DateTime.parse(row['updated_at'] as String),
  );
}
