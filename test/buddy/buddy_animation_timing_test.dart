import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/buddy/domain/usecases/buddy_animation_timing.dart';

void main() {
  test('Happy is held until its 100-frame one-shot finishes', () {
    expect(buddyReactionDuration('happy'), const Duration(milliseconds: 1800));
  });

  test('Energetic is held until its 64-frame one-shot finishes', () {
    expect(
      buddyReactionDuration('energetic'),
      const Duration(milliseconds: 1200),
    );
  });

  test('Idle does not schedule a reset timer', () {
    expect(buddyReactionDuration('neutral'), isNull);
    expect(buddyReactionDuration('idle'), isNull);
  });
}
