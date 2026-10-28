import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/foundation/domain/entities/foundation_status.dart';

void main() {
  test('stage three has immutable status', () {
    const status = FoundationStatus(cloudConfigured: false);
    expect(status.currentStage, 3);
    expect(status.totalStages, 9);
    expect(status.copyWith(cloudConfigured: true).cloudConfigured, isTrue);
  });
}
