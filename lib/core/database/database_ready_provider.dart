import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';

/// Created once Isar has successfully opened; can be overridden in widget tests.
final databaseReadyProvider = Provider<bool>((ref) {
  return ref.watch(localDatabaseProvider).isOpen;
});
