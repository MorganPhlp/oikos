import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'injection_container.dart' as di; // Ton injection de dépendances
import 'features/bilanCarbone/presentation/pages/bilan_page.dart';
import 'core/theme/app_colors.dart'; // Si tu veux appliquer le thème

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Config Supabase LOCAL
  // Attention : 10.0.2.2 est l'adresse spéciale pour que l'émulateur Android
  // accède au 'localhost' de ton ordinateur.
  await Supabase.initialize(
    url: 'http://10.0.2.2:41002', // Ton URL locale
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU', // Ta clé
    debug: true, // Affiche les logs Supabase dans la console (pratique !)
  );

  // 2. Injection de dépendances
  // Cela va créer le Repository qui utilisera l'instance Supabase configurée juste au-dessus
  await di.init(); 

  runApp(const MyTestApp());
}

class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test UI Bilan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightBackground,
        // Tu peux ajouter tes polices ici si besoin
      ),
      // On lance directement la page qu'on veut tester
      home: const BilanPage(),
    );
  }
}