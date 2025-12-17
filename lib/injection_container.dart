import 'package:get_it/get_it.dart';
import 'package:oikos/features/auth/data/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/bilan_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/reponse_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/services/QuestionnaireNavigator.dart';
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
  // 1. Externes (Outils techniques) - TOUJOURS EN PREMIER
  // ==========================================================
  sl.registerLazySingleton(() => Supabase.instance.client);

  // ==========================================================
  // 2. Data (Repositories & Services de données)
  // ==========================================================
  sl.registerLazySingleton<SimulationRepository>(() => PublicodesService());
  sl.registerLazySingleton<QuestionRepository>(() => QuestionRepositoryImpl(supabaseClient: sl()));
  sl.registerLazySingleton<ReponseRepository>(() => ReponseRepositoryImpl(supabaseClient: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(supabaseClient: sl()));
  sl.registerLazySingleton<BilanSessionRepository>(
    () => BilanSessionRepositoryImpl(supabaseClient: sl(), authRepo: sl()),
  );

  // ==========================================================
  // 3. Domaine (Services & Navigator)
  // ==========================================================
  sl.registerLazySingleton<ApplicabilityChecker>(() => ApplicabilityChecker(sl()));
  
  // ICI : Ajout du Navigator qui manquait
  sl.registerLazySingleton(() => QuestionnaireNavigator(sl()));

  // ==========================================================
  // 4. Use Cases (Dépendent du domaine et des repos)
  // ==========================================================
  sl.registerLazySingleton(() => DemarrerBilanUseCase(
        simulationRepo: sl(),
        questionRepo: sl(),
        bilanSessionRepo: sl(),
      ));

  sl.registerLazySingleton(() => EnregistrerReponseUseCase(
        simulationRepo: sl(),
        reponseRepo: sl(),
        bilanSessionRepo: sl(),
      ));
      
  // Si tu as décidé de passer par des Use Cases pour la navigation (recommandé) :
  // sl.registerLazySingleton(() => GetNextQuestionUseCase(sl()));
  // sl.registerLazySingleton(() => GetPreviousQuestionUseCase(sl()));

  // ==========================================================
  // 5. Présentation (Blocs/Cubits) - TOUJOURS EN DERNIER
  // ==========================================================
  sl.registerFactory(() => BilanCubit(
        demarrerBilanUseCase: sl(),
        repondreUseCase: sl(),
        navigator: sl(), // Maintenant sl() trouvera QuestionnaireNavigator
      ));
}