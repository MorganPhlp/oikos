import 'dart:convert';

/// Public client configuration injected at build time.
abstract final class AppSecrets {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const authRedirectUrl = String.fromEnvironment(
    'AUTH_REDIRECT_URL',
    defaultValue: 'http://localhost:3000/reset-password',
  );
  static void validate() {
    final uri = Uri.tryParse(supabaseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme) ||
        supabaseAnonKey.isEmpty) {
      throw StateError(
        'Configuration Supabase manquante : utiliser --dart-define-from-file=config/local.json.',
      );
    }
    var privileged = supabaseAnonKey.startsWith('sb_secret_');
    if (supabaseAnonKey.split('.').length == 3) {
      try {
        final payload = jsonDecode(
          utf8.decode(
            base64Url.decode(
              base64Url.normalize(supabaseAnonKey.split('.')[1]),
            ),
          ),
        );
        privileged = payload['role'] != 'anon';
      } on FormatException {
        throw StateError('Clé publique Supabase invalide.');
      }
    }
    if (privileged) {
      throw StateError(
        'Une clé secrète Supabase ne peut pas être utilisée par le client.',
      );
    }
  }
}
