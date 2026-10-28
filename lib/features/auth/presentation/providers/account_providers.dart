import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:nutri_buddy/features/auth/data/services/local_account_cleaner.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';

final localAccountCleanerProvider = Provider<LocalAccountCleaner>(
  (ref) => LocalAccountCleaner(ref.watch(localDatabaseProvider)),
);

/// Keep offline-first records on sign-out. They are owner-scoped and must
/// remain until synchronized; clearing them caused irreversible data loss.
Future<void> signOutPreservingLocalData(WidgetRef ref) async {
  final auth = ref.read(authRepositoryProvider);
  await auth.signOut();
}

/// Provides the pending local mutation count operation.
///
/// In production, this uses Isar through LocalAccountCleaner.
/// Widget tests can override it without opening a real database.
final localPendingCountProvider = Provider<Future<int> Function(String)>(
  (ref) => ref.watch(localAccountCleanerProvider).pendingCount,
);
