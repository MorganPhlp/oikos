import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour rootBundle
import 'package:supabase_flutter/supabase_flutter.dart';

// Tes imports (adapte les chemins si besoin)
import 'package:oikos/features/bilanCarbone/data/datasources/publicodes_service.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/question_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';

// --- CONFIG SUPABASE (LOCALE) ---
// Rappel : Android Emulator = 'http://10.0.2.2:41002' | iOS/Web/Windows = 'http://127.0.0.1:41002'
const supabaseUrl = 'http://10.0.2.2:41002'; 
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU';

void main() async {
  // 1. Initialisation de l'environnement Flutter (Obligatoire pour les plugins)
  WidgetsFlutterBinding.ensureInitialized();
  
  print("\n🔵 --- DÉMARRAGE DU TEST LOGIQUE (SANS UI) ---");

  // 2. Connexion Supabase
  print("🔌 Connexion à Supabase...");
  await Supabase.initialize(
    url: supabaseUrl, 
    anonKey: supabaseKey,
    debug: false // On désactive le debug supabase pour y voir clair
  );
  print("✅ Supabase connecté.");

  // 3. Initialisation des services
  print("⚙️ Initialisation du Moteur Publicodes...");
  final publicodesService = PublicodesService();
  await publicodesService.init();
  print("✅ Moteur JS prêt.");

  final questionRepo = QuestionRepositoryImpl(supabaseClient: Supabase.instance.client);

  try {
    // 4. Récupération des questions depuis la DB
    print("📥 Récupération des questions...");
    final questions = await questionRepo.getQuestions();
    print("✅ ${questions.length} questions trouvées.");
    
    if (questions.isEmpty) {
      print("❌ ERREUR: La table est vide. Exécute le script SQL d'abord.");
      return;
    }

    // --- DÉBUT DU SCÉNARIO DE TEST ---
    
    // Scénario : Je dis "NON" à la voiture.
    // Attendu : La question "KM" (index 1) doit être sautée.
    
    print("\n🎬 --- SCÉNARIO : Pas de voiture ---");

    QuestionBilanEntity q6 = questions[6];
    print("👉 Question 6 : ${q6.slug} (${q6.question})");
    bool q6Pertinente = publicodesService.isQuestionApplicable(q6.slug);
    print("   Est pertinente ? $q6Pertinente (Attendu: true)");

    publicodesService.updateSituation({
      q6.slug: "'propriétaire'"
    });
    QuestionBilanEntity q7 = questions[7];
    print("👉 Question 7 : ${q7.slug} (${q7.question})");
    bool q7Pertinente = publicodesService.isQuestionApplicable(q7.slug);
    print("   Est pertinente ? $q7Pertinente (Attendu: true)");

  } catch (e) {
    print("❌ ERREUR FATALE : $e");
  } finally {
    // Nettoyage
    publicodesService.dispose();
    print("\n🏁 --- FIN DU TEST ---");
    
    // On quitte proprement l'appli (sinon elle reste ouverte sur un écran noir)
    SystemNavigator.pop(); 
  }
}