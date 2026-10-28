import 'package:nutri_buddy/features/buddy/data/repositories/isar_pet_repository.dart';
import 'package:nutri_buddy/features/buddy/domain/entities/buddy_pet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Calls trusted RPCs; never accepts client-provided XP, gold or level.
final class BuddyCloudService {
  BuddyCloudService(this._client, this._local);
  final SupabaseClient _client;
  final IsarPetRepository _local;

  void _checkUser(String userId) {
    if (_client.auth.currentUser?.id != userId) {
      throw StateError('Oturum kullanıcısı değişti; tekrar giriş yap.');
    }
  }

  Future<BuddyPet> refresh(String userId) async {
    _checkUser(userId);
    await _client.rpc('claim_buddy_rewards');
    _checkUser(userId);
    final map = await _client
        .from('pets')
        .select('id, user_id, mood, xp, gold, level, streak_days, updated_at')
        .eq('user_id', userId)
        .single();
    _checkUser(userId);
    final pet = BuddyPet(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      mood: map['mood'] as String? ?? 'neutral',
      xp: (map['xp'] as num).toInt(),
      gold: (map['gold'] as num).toInt(),
      level: (map['level'] as num).toInt(),
      streakDays: (map['streak_days'] as num).toInt(),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
    await _local.cache(pet);
    return pet;
  }

  Future<List<Map<String, dynamic>>> catalog(String userId) async {
    _checkUser(userId);
    final rows = await _client
        .from('items')
        .select('id, sku, name, slot, asset_key, gold_price, active')
        .eq('active', true)
        .order('gold_price');
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Set<String>> ownedItemIds(String userId) async {
    _checkUser(userId);
    final rows = await _client
        .from('user_items')
        .select('item_id')
        .eq('user_id', userId);
    return (rows as List).map((row) => row['item_id'] as String).toSet();
  }

  Future<Set<String>> equippedItemIds(String userId) async {
    _checkUser(userId);
    final rows = await _client
        .from('user_items')
        .select('item_id')
        .eq('user_id', userId)
        .eq('equipped', true);
    return (rows as List).map((row) => row['item_id'] as String).toSet();
  }

  Future<void> purchase(String userId, String itemId) async {
    _checkUser(userId);
    await _client.rpc('buy_buddy_item', params: {'p_item_id': itemId});
    _checkUser(userId);
    await refresh(userId);
  }

  Future<void> equip(String userId, String itemId) async {
    _checkUser(userId);
    await _client.rpc('equip_buddy_item', params: {'p_item_id': itemId});
  }
}
