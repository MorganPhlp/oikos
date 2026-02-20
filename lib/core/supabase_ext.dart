import 'package:oikos/core/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension SupabaseDebug on SupabaseClient {
  String get dbSource {
    // Dans le SDK Supabase, l'URL se trouve dans rest.url
    final url = rest.url; 
    
    if (url.contains('localhost') || url.contains('127.0.0.1') || url.contains('10.0.2.2')) {
      return "🏠 LOCAL (Mocks/Docker)";
    }
    return "🌐 EXTERNE (Supabase Cloud)";
  }

  void logConnection() {
    logger.i("Supabase connecté à : $dbSource");
    logger.i("URL REST : ${rest.url}");

  }
}