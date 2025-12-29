import 'package:get_it/get_it.dart';
import 'package:oikos/core/data/category_empreinte_repository_impl.dart';
import 'package:oikos/core/data/utilisateur_repository_impl.dart';
import 'package:oikos/core/domain/repositories/categorie_empreinte_repository.dart';
import 'package:oikos/core/domain/repositories/utilisateur_repository.dart';
import 'package:oikos/features/auth/data/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/bilan_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/carbone_equivalent_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/reponse_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/carbone_equivalent_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/choix_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/definir_objectif_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_approfondissement_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/obtenir_objectifs_disponibles_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/preparer_choix_objectifs_use_case.dart';
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
  sl.registerLazySingleton<CategorieEmpreinteRepository>(
    () => CategorieEmpreinteRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<UtilisateurRepository>(
    () => UtilisateurRepositoryImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<CarboneEquivalentRepository>(
    () => CarboneEquivalentRepositoryImpl(supabaseClient: sl()),
  );
  // ==========================================================
  // 3. Domaine (Services & Navigator)
  // ==========================================================
  sl.registerLazySingleton<ApplicabilityChecker>(() => ApplicabilityChecker(sl()));
  

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

// ✅ DÉCOMMENTE ET CORRIGE LES NOMS ICI :
sl.registerLazySingleton(() => GetProchaineQuestionUseCase(
      applicabilityChecker: sl(),
    ));

sl.registerLazySingleton(() => GetPreviousQuestionUseCase(
      applicabilityChecker: sl(),
    ));

sl.registerLazySingleton(() => DemarrerApprofondissementUseCase(
      categorieRepo: sl(),
    ));

sl.registerLazySingleton(() => ChoixCategoriesUseCase(
      categorieRepo: sl(),
    ));
      
sl.registerLazySingleton(() => DefinirObjectifUseCase(
      utilisateurRepo: sl(),
    ));

sl.registerLazySingleton(() => CalculerBilanUseCase(
      simulationRepository: sl(),
    ));

sl.registerLazySingleton(() => RecupererEquivalentsCarboneUseCase(
      carboneEquivalentRepository: sl(),
    ));

sl.registerLazySingleton(() => CalculerBilanCategoriesUseCase(
      simulationRepository: sl(),
    ));

sl.registerLazySingleton(() => ObtenirObjectifsDisponiblesUseCase());

sl.registerLazySingleton(() => PreparerChoixObjectifsUseCase(
      calculerBilanUseCase: sl(),
      obtenirObjectifsUseCase: sl(),
    ));

  // ==========================================================
  // 5. Présentation (Blocs/Cubits) - TOUJOURS EN DERNIER
  // ==========================================================
  sl.registerFactory(() => BilanCubit(
        demarrerBilanUseCase: sl(),
        repondreUseCase: sl(),
        getNextUseCase: sl(),
        getPrevUseCase: sl(),
        choixCategoriesUseCase: sl(),
        demarrerApprofondissementUseCase: sl(),
        definirObjectifUseCase: sl(),
        calculerBilanUseCase: sl(),
        calculerBilanCategoriesUseCase: sl(),
        recupererEquivalentsCarboneUseCase: sl(),
        preparerChoixObjectifsUseCase: sl(),
      ));
}