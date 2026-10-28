/// Build-time configuration, read with --dart-define-from-file.
/// Never put service_role or OpenAI secret API keys in a mobile app.
abstract final class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get cloudConfigured =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  static void validate() {
    if (supabaseUrl.isEmpty != supabasePublishableKey.isEmpty) {
      throw StateError(
        'SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY must both be set.',
      );
    }

    if (supabaseUrl.isNotEmpty) {
      final uri = Uri.tryParse(supabaseUrl);
      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        throw StateError('SUPABASE_URL must be a valid absolute URL.');
      }
    }
  }
}
