import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/foundation/presentation/providers/foundation_provider.dart';

void main() {
  test('generated provider exposes stage three', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final status = container.read(foundationStatusProvider);
    expect(status.currentStage, 3);
    expect(status.totalStages, 9);
  });
}
