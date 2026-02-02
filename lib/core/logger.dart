import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,       // Nombre d'appels de fonctions à afficher
    errorMethodCount: 5,  // Pile d'appels si c'est une erreur
    lineLength: 80,       // Largeur du log
    colors: true,         // Couleurs pour VS Code / Android Studio
    printEmojis: true,    // Emojis pour identifier le type de log
  ),
  filter:ProductionFilter()

);

// Utilisation
// logger.d("Log de debug"); // 🔵
// logger.i("Info : Communauté chargée"); // 🟢
// logger.w("Attention : Code bientôt expiré"); // 🟡
// logger.e("Erreur critique Supabase", error: e); // 🔴