import 'package:get_it/get_it.dart';
import 'package:oikos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:oikos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/bilan_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/reponse_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
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
        demarrerBilanUseCase: sl(),
        repondreUseCase: sl(),
        prochaineQuestionUseCase: sl(),
        // Injection OK
      ));

  // ==========================================================
  // 2. Domaine (Services/Use Cases)
  // ==========================================================
  // Enregistrement du service de domaine. Il a besoin du SimulationRepository.
  sl.registerLazySingleton<ApplicabilityChecker>(
    // GetIt injectera l'instance de SimulationRepository
    () => ApplicabilityChecker(sl()),
  );

  // Use Case : Démarrer le Bilan
  sl.registerLazySingleton(() => DemarrerBilanUseCase(
        simulationRepo: sl(),
        questionRepo: sl(),
        bilanSessionRepo: sl(),
      ));

  sl.registerLazySingleton(() => GetProchaineQuestionUseCase(
        applicabilityChecker: sl(),
      ));

  sl.registerLazySingleton(() => EnregistrerReponseUseCase(
        simulationRepo: sl(),
        reponseRepo: sl(),
        bilanSessionRepo: sl(),
      ));
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

  sl.registerLazySingleton<BilanSessionRepository>(
    () => BilanSessionRepositoryImpl(
        supabaseClient: sl(), 
        authRepo: sl(),
    ),
  );

  sl.registerLazySingleton<ReponseRepository>(
    () => ReponseRepositoryImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(supabaseClient: sl(), remoteDataSource: AuthRemoteDataSourceImpl(supabaseClient: sl())),
  );

  // ==========================================================
  // 4. Data Sources & Externes (Outils techniques)
  // ==========================================================

  // Supabase Client (Déjà initialisé dans le main, on le récupère juste)
  sl.registerLazySingleton(() => Supabase.instance.client);
}
