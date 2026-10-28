import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/core/sync/models/pending_mutation_record.dart';
import 'package:nutri_buddy/core/sync/sync_acknowledgement.dart';
import 'package:nutri_buddy/features/meals/data/models/meal_log_record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Foreground, owner-scoped synchronization. Never remove an outbox mutation
/// until the server confirms it; a failed/mismatched session preserves the row.
final class MealCloudSyncService {
  MealCloudSyncService(this._isar, this._client);

  final Isar _isar;
  final SupabaseClient _client;
  Future<int>? _active;
  String? _activeOwner;

  void _assertOwner(String userId) {
    if (_client.auth.currentUser?.id != userId) {
      throw StateError('Sync aborted: account session changed');
    }
  }

  Future<int> syncPending(String userId) {
    if (_active != null) {
      if (_activeOwner != userId) {
        throw StateError('Sync already running for a different account');
      }
      return _active!;
    }
    _activeOwner = userId;
    final future = _replay(userId).whenComplete(() {
      _active = null;
      _activeOwner = null;
    });
    _active = future;
    return future;
  }

  Future<int> _replay(String userId) async {
    _assertOwner(userId);
    final queue = await _isar.pendingMutationRecords
        .filter()
        .userIdEqualTo(userId)
        .entityTypeEqualTo('logs')
        .sortByQueuedAt()
        .findAll();
    _assertOwner(userId);
    var confirmed = 0;

    for (final mutation in queue) {
      _assertOwner(userId);
      final record = await _isar.mealLogRecords
          .filter()
          .recordIdEqualTo(mutation.entityId)
          .findFirst();
      _assertOwner(userId);
      if (record == null || record.userId != userId) {
        // An outbox without its owned local record is not acknowledged.
        continue;
      }

      final changes = <String, dynamic>{
        'logged_at': record.loggedAt.toUtc().toIso8601String(),
        'name': record.name,
        'meal_type': record.mealType,
        'source': record.source,
        'calories_kcal': record.caloriesKcal,
        'protein_g': record.proteinG,
        'carbs_g': record.carbsG,
        'fat_g': record.fatG,
        'fiber_g': record.fiberG,
        'is_estimate': record.isEstimate,
        'is_deleted': record.isDeleted,
        'vision_details': record.visionDetailsJson == null
            ? null
            : jsonDecode(record.visionDetailsJson!),
        'recipe_details': record.recipeDetailsJson == null
            ? null
            : jsonDecode(record.recipeDetailsJson!),
      };

      // Insert-if-absent supports a retry after a crash between upload and ack.
      // Updates only contain Stage 2's editable columns (no user_id/revision).
      if (!record.isDeleted) {
        _assertOwner(userId);
        await _client
            .from('logs')
            .upsert(
              {'id': record.recordId, 'user_id': userId, ...changes},
              onConflict: 'id',
              ignoreDuplicates: true,
            );
        _assertOwner(userId);
      }

      // A successful HTTP status does not mean a row was updated. SELECT
      // returns exactly the rows acknowledged by PostgREST under owner RLS.
      _assertOwner(userId);
      final updated = await _client
          .from('logs')
          .update(changes)
          .eq('id', record.recordId)
          .eq('user_id', userId)
          .select('id,revision');
      _assertOwner(userId);

      int? serverRevision;
      if (updated.isEmpty && record.isDeleted && record.serverRevision == 0) {
        // Local-only deletion: the row may never have reached Supabase.
        // Confirm no owner-visible row exists before treating it as a no-op.
        _assertOwner(userId);
        final existing = await _client
            .from('logs')
            .select('id')
            .eq('id', record.recordId)
            .eq('user_id', userId);
        _assertOwner(userId);
        if (existing.isNotEmpty) {
          throw StateError('Remote deletion could not be confirmed');
        }
      } else {
        serverRevision = requireConfirmedRevision(
          recordId: record.recordId,
          rows: updated,
        );
      }

      final applied = await _isar.writeTxn(() async {
        _assertOwner(userId);
        final latest = await _isar.mealLogRecords
            .filter()
            .recordIdEqualTo(record.recordId)
            .findFirst();
        final currentMutation = await _isar.pendingMutationRecords.get(
          mutation.id,
        );
        if (latest == null ||
            latest.userId != userId ||
            !latest.pendingSync ||
            currentMutation == null ||
            currentMutation.userId != userId ||
            currentMutation.entityType != 'logs' ||
            currentMutation.entityId != record.recordId ||
            latest.updatedAt.millisecondsSinceEpoch !=
                record.updatedAt.millisecondsSinceEpoch ||
            latest.isDeleted != record.isDeleted) {
          // A newer edit/outbox entry exists; leave it queued.
          return false;
        }
        _assertOwner(userId);
        latest.pendingSync = false;
        if (serverRevision != null) {
          latest.serverRevision = serverRevision;
        }
        await _isar.mealLogRecords.put(latest);
        await _isar.pendingMutationRecords.delete(mutation.id);
        return true;
      });
      if (applied) confirmed++;
    }
    return confirmed;
  }
}
