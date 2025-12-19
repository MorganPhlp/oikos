import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_cubit.dart';
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
  final client = Supabase.instance.client;

  // 1. Nettoyage radical du cache local
  await client.auth.signOut();
  
  const String testEmail = 'jamel.debbouze@viveris.fr';
  const String testPassword = 'password123';

  // 2. Connexion ou Inscription avec récupération explicite du résultat
  AuthResponse res;
  try {
    // On essaie de se connecter d'abord
    res = await client.auth.signInWithPassword(email: testEmail, password: testPassword);
    print("✅ Utilisateur existant connecté");
  } catch (e) {
    // Si échec, on crée le compte
    res = await client.auth.signUp(email: testEmail, password: testPassword);
    print("✅ Nouvel utilisateur créé dans Auth");
  }

  // 💡 LE FIX CRUCIAL : On attend que PostgreSQL propage l'utilisateur dans auth.users
  await Future.delayed(const Duration(milliseconds: 1000));

  final user = res.user;
  if (user != null) {
    try {
      // 3. SYNCHRONISATION
      // On utilise upsert pour écraser si l'id existe déjà
      await client.from('utilisateur').upsert({
        'id': user.id,
        'email': user.email,
        'pseudo': user.email!.split('@')[0],
        'role': 'UTILISATEUR',
        'etat_compte': 'ACTIF',
        'est_compte_valide': true,
        'a_accepte_cgu': true,
      });
      print("🚀 Table 'public.utilisateur' synchronisée avec succès !");
    } catch (e) {
      print("❌ Erreur de synchronisation toujours présente : $e");
      // Si l'erreur persiste ici, ton instance Supabase locale doit être reset
    }
  }

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
      ),
      // 💡 C'EST ICI : On enveloppe la "home" ou le Navigator avec le provider
      home: BlocProvider(
        create: (context) => di.sl<BilanCubit>()..demarrerBilan(),
        child: const BilanPage(),
      ),
    );
  }
}