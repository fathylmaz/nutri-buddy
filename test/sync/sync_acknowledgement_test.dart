import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/core/sync/sync_acknowledgement.dart';

void main() {
  test('accepts one matching row with a positive server revision', () {
    expect(
      requireConfirmedRevision(
        recordId: 'mine',
        rows: [
          <String, dynamic>{'id': 'mine', 'revision': 7},
        ],
      ),
      7,
    );
  });

  test('zero rows never acknowledge a successful HTTP response', () {
    expect(
      () => requireConfirmedRevision(recordId: 'mine', rows: []),
      throwsStateError,
    );
  });

  test('a different row cannot acknowledge a local mutation', () {
    expect(
      () => requireConfirmedRevision(
        recordId: 'mine',
        rows: [
          <String, dynamic>{'id': 'other', 'revision': 1},
        ],
      ),
      throwsStateError,
    );
  });

  test('missing server revision is not an acknowledgement', () {
    expect(
      () => requireConfirmedRevision(
        recordId: 'mine',
        rows: [
          <String, dynamic>{'id': 'mine'},
        ],
      ),
      throwsStateError,
    );
  });

  test('multiple returned rows are not a single-row acknowledgement', () {
    expect(
      () => requireConfirmedRevision(
        recordId: 'mine',
        rows: [
          <String, dynamic>{'id': 'mine', 'revision': 2},
          <String, dynamic>{'id': 'mine', 'revision': 3},
        ],
      ),
      throwsStateError,
    );
  });
}
