import 'package:isar_community/isar.dart';
import 'package:nutri_buddy/features/buddy/data/models/pet_record.dart';
import 'package:nutri_buddy/features/buddy/domain/entities/buddy_pet.dart';
import 'package:nutri_buddy/features/buddy/domain/repositories/petrepository.dart';

/// User-scoped offline snapshot; the authoritative XP balance is on Supabase.
final class IsarPetRepository implements PetRepository {
  IsarPetRepository(this._isar);
  final Isar _isar;

  BuddyPet _map(PetRecord r) => BuddyPet(
    id: r.recordId,
    userId: r.userId,
    mood: r.mood,
    xp: r.xp,
    gold: r.gold,
    level: r.level,
    streakDays: r.streakDays,
    updatedAt: r.updatedAt,
  );

  @override
  Future<BuddyPet?> getForUser(String userId) async {
    final item = await _isar.petRecords
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    return item == null ? null : _map(item);
  }

  Stream<BuddyPet?> watchForUser(String userId) => _isar.petRecords
      .filter()
      .userIdEqualTo(userId)
      .watch(fireImmediately: true)
      .map((items) => items.isEmpty ? null : _map(items.first));

  Future<void> cache(BuddyPet incoming) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.petRecords
          .filter()
          .userIdEqualTo(incoming.userId)
          .findFirst();
      // Ignore old async responses and preserve a newer downloaded snapshot.
      if (existing != null && existing.updatedAt.isAfter(incoming.updatedAt)) {
        return;
      }
      final item = PetRecord()
        ..id = existing?.id ?? Isar.autoIncrement
        ..recordId = incoming.id
        ..userId = incoming.userId
        ..mood = incoming.mood
        ..xp = incoming.xp
        ..gold = incoming.gold
        ..level = incoming.level
        ..streakDays = incoming.streakDays
        ..updatedAt = incoming.updatedAt
        ..serverRevision = existing?.serverRevision ?? 0;
      await _isar.petRecords.put(item);
    });
  }
}
