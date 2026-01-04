import 'package:get_it/get_it.dart';
import 'package:oikos/core/data/category_empreinte_repository_impl.dart';
import 'package:oikos/core/data/utilisateur_repository_impl.dart';
import 'package:oikos/core/domain/repositories/categorie_empreinte_repository.dart';
import 'package:oikos/core/domain/repositories/utilisateur_repository.dart';
import 'package:oikos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:oikos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/usecases/current_user.dart';
import 'package:oikos/features/auth/domain/usecases/user_signin.dart';
import 'package:oikos/features/auth/domain/usecases/user_signup.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/bilanCarbone/data/datasources/publicodes_service.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/bilan_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/carbone_equivalent_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/question_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/data/repositories/reponse_repository_impl.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/carbone_equivalent_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/choix_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/definir_objectif_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_approfondissement_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/obtenir_objectifs_disponibles_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/preparer_choix_objectifs_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBilan();
  final supabase = await Supabase.initialize(
    // Initialize Supabase
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Data source
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      supabaseClient: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => UserSignin(repository: serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserSignup(serviceLocator()));

  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  // Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignup: serviceLocator(),
      userSignin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

  void _initBilan() {
  // ==========================================================
  // DATA (Repositories & Services)
  // ==========================================================
  serviceLocator.registerLazySingleton<SimulationRepository>(() => PublicodesService());
  serviceLocator.registerLazySingleton<QuestionRepository>(() => QuestionRepositoryImpl(supabaseClient: serviceLocator()));
  serviceLocator.registerLazySingleton<ReponseRepository>(() => ReponseRepositoryImpl(supabaseClient: serviceLocator()));
  serviceLocator.registerLazySingleton<BilanSessionRepository>(
    () => BilanSessionRepositoryImpl(supabaseClient: serviceLocator(), authRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CategorieEmpreinteRepository>(
    () => CategorieEmpreinteRepositoryImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<UtilisateurRepository>(
    () => UtilisateurRepositoryImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CarboneEquivalentRepository>(
    () => CarboneEquivalentRepositoryImpl(supabaseClient: serviceLocator()),
  );

  // ==========================================================
  // DOMAINE (Services & Use Cases)
  // ==========================================================
  serviceLocator.registerLazySingleton(() => ApplicabilityChecker(serviceLocator()));

  serviceLocator.registerLazySingleton(() => DemarrerBilanUseCase(
        simulationRepo: serviceLocator(),
        questionRepo: serviceLocator(),
        bilanSessionRepo: serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => EnregistrerReponseUseCase(
        simulationRepo: serviceLocator(),
        reponseRepo: serviceLocator(),
        bilanSessionRepo: serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(() => GetProchaineQuestionUseCase(applicabilityChecker: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetPreviousQuestionUseCase(applicabilityChecker: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DemarrerApprofondissementUseCase(categorieRepo: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ChoixCategoriesUseCase(categorieRepo: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DefinirObjectifUseCase(utilisateurRepo: serviceLocator()));
  serviceLocator.registerLazySingleton(() => CalculerBilanUseCase(simulationRepository: serviceLocator(), bilanRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => RecupererEquivalentsCarboneUseCase(carboneEquivalentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => CalculerBilanCategoriesUseCase(simulationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ObtenirObjectifsDisponiblesUseCase());
  serviceLocator.registerLazySingleton(() => PreparerChoixObjectifsUseCase(
        calculerBilanUseCase: serviceLocator(),
        obtenirObjectifsUseCase: serviceLocator(),
      ));

  // ==========================================================
  // PRESENTATION (Bloc)
  // ==========================================================
  serviceLocator.registerFactory(() => BilanBloc(
        demarrerBilanUseCase: serviceLocator(),
        repondreUseCase: serviceLocator(),
        getNextUseCase: serviceLocator(),
        getPrevUseCase: serviceLocator(),
        choixCategoriesUseCase: serviceLocator(),
        demarrerApprofondissementUseCase: serviceLocator(),
        definirObjectifUseCase: serviceLocator(),
        calculerBilanUseCase: serviceLocator(),
        calculerBilanCategoriesUseCase: serviceLocator(),
        recupererEquivalentsCarboneUseCase: serviceLocator(),
        preparerChoixObjectifsUseCase: serviceLocator(),
      ));
}