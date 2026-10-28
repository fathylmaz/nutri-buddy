import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/analytics/data/models/weight_record.dart';
import 'package:nutri_buddy/features/analytics/data/services/weight_cloud_sync_service.dart';
import 'package:nutri_buddy/features/dashboard/data/models/water_record.dart';
import 'package:nutri_buddy/features/dashboard/data/services/water_cloud_sync_service.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:nutri_buddy/features/meals/data/services/meal_cloud_sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Cloud hydration only: never deletes local rows and never overwrites pending
/// local changes. All remote queries are owner-filtered and protected by RLS.
final accountCloudRestoreProvider = Provider<AccountCloudRestoreService?>((
  ref,
) {
  if (!AppConfig.cloudConfigured) {
    return null;
  }
  return AccountCloudRestoreService(
    ref.watch(localDatabaseProvider),
    Supabase.instance.client,
  );
});

/// Pure conflict rule that is testable without an Isar or network connection.
/// Tombstones are persisted for existing rows so remote deletions stay hidden.
bool shouldApplyCloudRecord({
  required bool existsLocally,
  required bool locallyPending,
  required int localRevision,
  required int cloudRevision,
  required bool cloudDeleted,
}) {
  if (locallyPending) {
    return false;
  }
  if (!existsLocally) {
    return !cloudDeleted;
  }
  return cloudRevision > localRevision;
}

class CloudRestoreResult {
  const CloudRestoreResult({
    required this.meals,
    required this.waters,
    required this.weights,
    required this.uploadsComplete,
  });
  final int meals;
  final int waters;
  final int weights;
  final bool uploadsComplete;
}

final class AccountCloudRestoreService {
  AccountCloudRestoreService(this._isar, this._client);
  final Isar _isar;
  final SupabaseClient _client;
  static const _pageSize = 250;
  Future<CloudRestoreResult>? _active;
  String? _activeOwner;

  void _assertOwner(String userId) {
    if (_client.auth.currentUser?.id != userId) {
      throw StateError('Bulut kayıtları için oturum sahibi değişti.');
    }
  }

  Future<CloudRestoreResult> restore(String userId) {
    if (_active != null) {
      if (_activeOwner != userId) {
        throw StateError('Başka bir hesap için eşitleme sürüyor.');
      }
      return _active!;
    }
    _activeOwner = userId;
    final task = _restore(userId);
    _active = task;
    return task.whenComplete(() {
      _active = null;
      _activeOwner = null;
    });
  }

  Future<CloudRestoreResult> _restore(String userId) async {
    _assertOwner(userId);
    var uploadsComplete = true;
    // Replay outstanding local mutations while the matching account is signed in.
    // Even if one upload fails, continue with safe cloud downloads. Local pending
    // rows always win, and no local data is cleared on errors.
    for (final sync in <Future<int> Function()>[
      () => WaterCloudSyncService(_isar, _client).syncPending(userId),
      () => MealCloudSyncService(_isar, _client).syncPending(userId),
      () => WeightCloudSyncService(_isar, _client).syncPending(userId),
    ]) {
      try {
        _assertOwner(userId);
        await sync();
      } catch (_) {
        uploadsComplete = false;
      }
    }
    final meals = await _restoreMeals(userId);
    final waters = await _restoreWaters(userId);
    final weights = await _restoreWeights(userId);
    return CloudRestoreResult(
      meals: meals,
      waters: waters,
      weights: weights,
      uploadsComplete: uploadsComplete,
    );
  }

  Future<List<Map<String, dynamic>>> _getPage(
    String table,
    String userId,
    int offset,
  ) async {
    _assertOwner(userId);
    final result = await _client
        .from(table)
        .select()
        .eq('user_id', userId)
        .order('id', ascending: true)
        .range(offset, offset + _pageSize - 1);
    _assertOwner(userId);
    return [for (final row in result) Map<String, dynamic>.from(row)];
  }

  static int _revision(Map<String, dynamic> row) =>
      (row['revision'] as num?)?.toInt() ?? 1;

  static DateTime _date(Object? value) =>
      DateTime.parse(value as String).toUtc();

  static String? _json(Object? data) => data == null ? null : jsonEncode(data);

  Future<int> _restoreMeals(String userId) async {
    var added = 0;
    for (var offset = 0; ; offset += _pageSize) {
      final rows = await _getPage('logs', userId, offset);
      await _isar.writeTxn(() async {
        _assertOwner(userId);
        for (final row in rows) {
          if (row['user_id'] != userId) {
            continue;
          }
          final id = row['id'] as String;
          final current = await _isar.mealLogRecords
              .filter()
              .recordIdEqualTo(id)
              .findFirst();
          if (current != null && current.userId != userId) {
            continue;
          }
          final deleted = row['is_deleted'] as bool? ?? false;
          if (!shouldApplyCloudRecord(
            existsLocally: current != null,
            locallyPending: current?.pendingSync ?? false,
            localRevision: current?.serverRevision ?? 0,
            cloudRevision: _revision(row),
            cloudDeleted: deleted,
          )) {
            continue;
          }
          final model = MealLogRecord()
            ..id = current?.id ?? Isar.autoIncrement
            ..recordId = id
            ..userId = userId
            ..loggedAt = _date(row['logged_at'])
            ..name = row['name'] as String
            ..mealType = row['meal_type'] as String
            ..source = row['source'] as String
            ..caloriesKcal = (row['calories_kcal'] as num).toInt()
            ..proteinG = (row['protein_g'] as num).toDouble()
            ..carbsG = (row['carbs_g'] as num).toDouble()
            ..fatG = (row['fat_g'] as num).toDouble()
            ..fiberG = (row['fiber_g'] as num).toDouble()
            ..isEstimate = row['is_estimate'] as bool? ?? true
            ..isDeleted = deleted
            ..visionDetailsJson = _json(row['vision_details'])
            ..recipeDetailsJson = _json(row['recipe_details'])
            ..updatedAt = _date(row['updated_at'])
            ..pendingSync = false
            ..serverRevision = _revision(row);
          await _isar.mealLogRecords.put(model);
          if (current == null) {
            added++;
          }
        }
      });
      if (rows.length < _pageSize) {
        break;
      }
    }
    return added;
  }

  Future<int> _restoreWaters(String userId) async {
    var added = 0;
    for (var offset = 0; ; offset += _pageSize) {
      final rows = await _getPage('water_entries', userId, offset);
      await _isar.writeTxn(() async {
        _assertOwner(userId);
        for (final row in rows) {
          if (row['user_id'] != userId) {
            continue;
          }
          final id = row['id'] as String;
          final current = await _isar.waterRecords
              .filter()
              .recordIdEqualTo(id)
              .findFirst();
          if (current != null && current.userId != userId) {
            continue;
          }
          final deleted = row['is_deleted'] as bool? ?? false;
          if (!shouldApplyCloudRecord(
            existsLocally: current != null,
            locallyPending: current?.pendingSync ?? false,
            localRevision: current?.serverRevision ?? 0,
            cloudRevision: _revision(row),
            cloudDeleted: deleted,
          )) {
            continue;
          }
          final model = WaterRecord()
            ..id = current?.id ?? Isar.autoIncrement
            ..recordId = id
            ..userId = userId
            ..recordedAt = _date(row['recorded_at'])
            ..amountMl = (row['amount_ml'] as num).toInt()
            ..isDeleted = deleted
            ..updatedAt = _date(row['updated_at'])
            ..pendingSync = false
            ..serverRevision = _revision(row);
          await _isar.waterRecords.put(model);
          if (current == null) {
            added++;
          }
        }
      });
      if (rows.length < _pageSize) {
        break;
      }
    }
    return added;
  }

  Future<int> _restoreWeights(String userId) async {
    var added = 0;
    for (var offset = 0; ; offset += _pageSize) {
      final rows = await _getPage('weight_entries', userId, offset);
      await _isar.writeTxn(() async {
        _assertOwner(userId);
        for (final row in rows) {
          if (row['user_id'] != userId) {
            continue;
          }
          final id = row['id'] as String;
          final current = await _isar.weightRecords
              .filter()
              .recordIdEqualTo(id)
              .findFirst();
          if (current != null && current.userId != userId) {
            continue;
          }
          final deleted = row['is_deleted'] as bool? ?? false;
          if (!shouldApplyCloudRecord(
            existsLocally: current != null,
            locallyPending: current?.pendingSync ?? false,
            localRevision: current?.serverRevision ?? 0,
            cloudRevision: _revision(row),
            cloudDeleted: deleted,
          )) {
            continue;
          }
          final model = WeightRecord()
            ..id = current?.id ?? Isar.autoIncrement
            ..recordId = id
            ..userId = userId
            ..recordedAt = _date(row['recorded_at'])
            ..weightKg = (row['weight_kg'] as num).toDouble()
            ..isDeleted = deleted
            ..updatedAt = _date(row['updated_at'])
            ..pendingSync = false
            ..serverRevision = _revision(row);
          await _isar.weightRecords.put(model);
          if (current == null) {
            added++;
          }
        }
      });
      if (rows.length < _pageSize) {
        break;
      }
    }
    return added;
  }
}
