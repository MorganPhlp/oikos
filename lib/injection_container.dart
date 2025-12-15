import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Imports de tes classes (Adapte les chemins si besoin)
import 'features/bilanCarbone/data/datasources/publicodes_service.dart';
import 'features/bilanCarbone/data/repositories/question_repository_impl.dart';
import 'features/bilanCarbone/domain/repositories/question_repository.dart';
import 'features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'features/bilanCarbone/presentation/bloc/bilan_cubit.dart';
import 'features/bilanCarbone/domain/services/applicability_checker.dart';

// La variable globale 'sl' qu'on utilisera partout
final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================================
  // 1. Présentation (Blocs)
  // ==========================================================
  // On utilise 'registerFactory' pour avoir un nouveau Cubit neuf à chaque fois
  sl.registerFactory(() => BilanCubit(
        simulationRepo: sl(),
        questionRepo: sl(),
        applicabilityChecker: sl(), // Injection OK
      ));

  // ==========================================================
  // 2. Domaine (Services/Use Cases)
  // ==========================================================
  // Enregistrement du service de domaine. Il a besoin du SimulationRepository.
  sl.registerLazySingleton<ApplicabilityChecker>(
    // GetIt injectera l'instance de SimulationRepository
    () => ApplicabilityChecker(sl()),
  );

  // ==========================================================
  // 3. Data (Repositories & Implementations)
  // ==========================================================
  // Simulation : Enregistrement de l'implémentation sous son interface
  sl.registerLazySingleton<SimulationRepository>(
    // L'implémentation PublicodesService est utilisée ici
    () => PublicodesService(),
  );

  // Questions (Supabase)
  sl.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(supabaseClient: sl()),
  );

  // ==========================================================
  // 4. Data Sources & Externes (Outils techniques)
  // ==========================================================

  // Supabase Client (Déjà initialisé dans le main, on le récupère juste)
  sl.registerLazySingleton(() => Supabase.instance.client);
}
