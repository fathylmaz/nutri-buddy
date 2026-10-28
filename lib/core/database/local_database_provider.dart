import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

/// Overridden from bootstrap only after opening all Isar schemas.
final localDatabaseProvider = Provider<Isar>((ref) {
  throw StateError('LocalDatabase was not initialized');
});
