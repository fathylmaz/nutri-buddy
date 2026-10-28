import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/onboarding/data/mappers/user_profile_mapper.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';

void main() {
  test('user profile maps through local record with an owner id', () {
    final updated = DateTime.utc(2026, 10, 22);
    final profile = UserProfile(
      id: 'account-1',
      displayName: 'Test',
      weightKg: 70,
      allergies: const ['susam'],
      updatedAt: updated,
    );
    final record = UserProfileMapper.toRecord(profile);
    expect(record.userId, 'account-1');
    expect(record.allergies, ['susam']);
    expect(UserProfileMapper.toDomain(record), profile);
  });
}
