/// Rejects a successful HTTP response that did not actually acknowledge
/// exactly the expected database row. Used before removing Isar outbox entries.
int requireConfirmedRevision({
  required String recordId,
  required List<Map<String, dynamic>> rows,
}) {
  if (rows.length != 1 || rows.single['id'] != recordId) {
    throw StateError('Supabase did not acknowledge the expected record');
  }
  final raw = rows.single['revision'];
  if (raw is! num || !raw.isFinite || raw < 1 || raw != raw.roundToDouble()) {
    throw StateError('Supabase acknowledgement has no valid revision');
  }
  return raw.toInt();
}
