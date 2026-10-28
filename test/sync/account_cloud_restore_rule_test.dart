import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/core/sync/account_cloud_restore_service.dart';

void main() {
  test('new active cloud records can be restored', () {
    expect(
      shouldApplyCloudRecord(
        existsLocally: false,
        locallyPending: false,
        localRevision: 0,
        cloudRevision: 2,
        cloudDeleted: false,
      ),
      isTrue,
    );
  });
  test('never resurrect a remote tombstone that is absent locally', () {
    expect(
      shouldApplyCloudRecord(
        existsLocally: false,
        locallyPending: false,
        localRevision: 0,
        cloudRevision: 8,
        cloudDeleted: true,
      ),
      isFalse,
    );
  });
  test('unsynced local edits survive even when cloud revision is higher', () {
    expect(
      shouldApplyCloudRecord(
        existsLocally: true,
        locallyPending: true,
        localRevision: 1,
        cloudRevision: 8,
        cloudDeleted: true,
      ),
      isFalse,
    );
  });
  test('newer remote revision updates synced local record', () {
    expect(
      shouldApplyCloudRecord(
        existsLocally: true,
        locallyPending: false,
        localRevision: 2,
        cloudRevision: 3,
        cloudDeleted: true,
      ),
      isTrue,
    );
  });
  test('older cloud data cannot replace local synced cache', () {
    expect(
      shouldApplyCloudRecord(
        existsLocally: true,
        locallyPending: false,
        localRevision: 7,
        cloudRevision: 4,
        cloudDeleted: false,
      ),
      isFalse,
    );
  });
}
