import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:oikos/core/common/data/category_empreinte_repository_impl.dart';
import 'package:oikos/core/common/data/utilisateur_repository_impl.dart';
import 'package:oikos/core/common/domain/repositories/categorie_empreinte_repository.dart';
import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/ecarter_action_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/ecarter_categorie_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/ecarter_tag_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/get_limite_actions_freq_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/get_my_habitudes_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/promote_to_habitude_use_case.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/habitudes_cubit.dart';
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
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/initialiser_moteur_de_calcul_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/obtenir_objectifs_disponibles_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/preparer_choix_objectifs_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recommencer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_questions_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_reponses_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/reprendre_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/verifier_bilan_en_cours_use_case.dart';
import 'package:oikos/features/profile/data/repositories/bilan_repository_impl.dart';
import 'package:oikos/features/profile/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/profile/domain/use_cases/get_questions_restantes_use_case.dart';
import 'package:oikos/features/profile/presentation/bloc/profile_bilan_cubit.dart';
import 'package:oikos/features/streak/data/datasources/streak_remote_datasource.dart';
import 'package:oikos/features/streak/data/repositories/streak_repository_impl.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';
import 'package:oikos/features/streak/domain/use_cases/calculer_progres_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/get_streak_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/mark_streak_as_seen_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/recuperer_streak_steps_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/watch_streak_use_case.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';

import 'core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'core/secrets/app_secrets.dart';
import 'features/auth/domain/usecases/delete_account.dart';
import 'features/auth/domain/usecases/reset_password.dart';
import 'features/auth/domain/usecases/update_credentials.dart';
import 'features/auth/domain/usecases/update_user.dart';
import 'features/auth/domain/usecases/user_signout.dart';
import 'features/auth/domain/usecases/validate_email_password.dart';
import 'features/auth/domain/usecases/validate_pseudo.dart';

import 'package:oikos/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:oikos/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:oikos/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:oikos/features/dashboard/domain/usecases/get_my_profile.dart';
import 'package:oikos/features/dashboard/presentation/bloc/dashboard_bloc.dart';

//Imports Code barre
import 'package:oikos/features/codeBarre/data/datasources/code_barre_remote_data_source.dart';
import 'package:oikos/features/codeBarre/data/repositories/aliment_repository_impl.dart';
import 'package:oikos/features/codeBarre/domain/repositories/aliment_repository.dart';
import 'package:oikos/features/codeBarre/domain/usecases/get_aliment_by_code.dart';
import 'package:oikos/features/codeBarre/presentation/bloc/scan_bloc.dart';

import 'features/codeBarre/domain/usecases/get_alternative_product.dart';
import 'features/codeBarre/presentation/cubit/alternative_product_cubit.dart';

import 'package:oikos/features/actions_et_defis/data/datasources/action_remote_data_source.dart';
import 'package:oikos/features/actions_et_defis/data/repositories/action_repository_impl.dart';
import 'package:oikos/features/actions_et_defis/domain/repositories/action_repository.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/get_actions.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/get_my_active_actions_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/add_to_my_actions_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/validate_action_use_case.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/remove_from_my_actions_use_case.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/actions_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Supabase FIRST before other dependencies
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      authFlowType: kIsWeb
          ? AuthFlowType.implicit
          : AuthFlowType
                .pkce, // Pour éviter les problèmes de redirection sur le web, on utilise le flow implicite qui gère tout côté client. C'est plus simple et sécurisé pour une application Flutter.
    ),
  );
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  // Enregistrement du Client HTTP (Indispensable pour le Scanner Code Barre)
  serviceLocator.registerLazySingleton(() => http.Client());

  // core

  serviceLocator.registerLazySingleton(
    () => AppUserCubit(serviceLocator<UtilisateurRepository>()),
  );
  // Then initialize auth and bilan after Supabase is ready
  _initAuth();
  _initBilan();
  _initCodeBarre();
  _initStreak();
  _initProfile();
  _initDashboard();
  _initActions();
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
    () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => UserSignin(repository: serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserSignup(serviceLocator()));

  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  serviceLocator.registerFactory(() => ValidateEmailPassword(serviceLocator()));

  serviceLocator.registerFactory(() => ValidatePseudo(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignOut(serviceLocator()));

  serviceLocator.registerFactory(() => ResetPassword(serviceLocator()));

  serviceLocator.registerLazySingleton(() => UpdateUser(serviceLocator()));

  serviceLocator.registerLazySingleton(() => DeleteAccount(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => UpdateCredentials(serviceLocator()),
  );

  // Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignup: serviceLocator(),
      userSignin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
      authRepository: serviceLocator(),
      validateEmailPassword: serviceLocator(),
      validatePseudo: serviceLocator(),
      userSignOut: serviceLocator(),
      resetPassword: serviceLocator(),
      updateUser: serviceLocator(),
      deleteAccount: serviceLocator(),
      updateCredentials: serviceLocator(),
    ),
  );
}

void _initBilan() {
  // ==========================================================
  // DATA (Repositories & Services)
  // ==========================================================
  serviceLocator.registerLazySingleton<SimulationRepository>(
    () => PublicodesService(),
  );
  serviceLocator.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ReponseRepository>(
    () => ReponseRepositoryImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<BilanSessionRepository>(
    () => BilanSessionRepositoryImpl(supabaseClient: serviceLocator()),
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

  serviceLocator.registerLazySingleton(
    () => InitialiserMoteurDeCalculUseCase(
      simulationRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ApplicabilityChecker(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => EnregistrerReponseUseCase(
      simulationRepo: serviceLocator(),
      reponseRepo: serviceLocator(),
      bilanSessionRepo: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetProchaineQuestionUseCase(
      applicabilityChecker: serviceLocator(),
      reponseRepository: serviceLocator(),
      bilanSessionRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetPreviousQuestionUseCase(applicabilityChecker: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DemarrerApprofondissementUseCase(categorieRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ChoixCategoriesUseCase(categorieRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DefinirObjectifUseCase(utilisateurRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CalculerBilanUseCase(
      simulationRepository: serviceLocator(),
      bilanRepository: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => RecupererEquivalentsCarboneUseCase(
      carboneEquivalentRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () =>
        CalculerBilanCategoriesUseCase(simulationRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ObtenirObjectifsDisponiblesUseCase(),
  );
  serviceLocator.registerLazySingleton(
    () => PreparerChoixObjectifsUseCase(
      calculerBilanUseCase: serviceLocator(),
      obtenirObjectifsUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => VerifierBilanEnCoursUseCase(
      bilanSessionRepo: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RecommencerBilanUseCase(
      bilanSessionRepository: serviceLocator(),
      questionRepository: serviceLocator(),
      simulationRepository: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RecupererReponsesUseCase(
      reponseRepository: serviceLocator(),
      bilanRepository: serviceLocator(),
      questionRepository: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ReprendreBilanUseCase(
      reponseRepository: serviceLocator(),
      bilanRepository: serviceLocator(),
      simulationRepository: serviceLocator(),
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RecupererQuestionsUseCase(questionRepository: serviceLocator()),
  );

  // ==========================================================
  // PRESENTATION (Bloc)
  // ==========================================================
  // 1. Gestion du cycle de vie (Reprise / Nouveau)
  serviceLocator.registerFactory(
    () => BilanSessionBloc(
      verifierBilanUseCase: serviceLocator(),
      recupererQuestionsUseCase: serviceLocator(),
      recupererReponsesUseCase: serviceLocator(),
      recommencerBilanUseCase: serviceLocator(),
    ),
  );

  // 2. Moteur du questionnaire (Navigation questions)
  serviceLocator.registerFactory(
    () => QuestionnaireBloc(
      repondreUseCase: serviceLocator(),
      getNextUseCase: serviceLocator(),
      getPrevUseCase: serviceLocator(),
      reprendreBilanUseCase: serviceLocator(),
      initialiserMoteurDeCalculUseCase: serviceLocator(),
    ),
  );

  // 3. Phase de résultats (Approfondissement / Objectifs)
  serviceLocator.registerFactory(
    () => BilanResultatBloc(
      demarrerApproUseCase: serviceLocator(),
      choixCategoriesUseCase: serviceLocator(),
      preparerObjectifsUseCase: serviceLocator(),
      definirObjectifUseCase: serviceLocator(),
      calculerCategoriesUseCase: serviceLocator(),
      equivalentsUseCase: serviceLocator(),
      calculerBilanUseCase: serviceLocator(),
    ),
  );
}

void _initDashboard() {
  // Datasource : création du la connexion à la bdd
  serviceLocator.registerFactory<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository: on donne la co au repository
  serviceLocator.registerFactory<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // UseCase : on donne le repo au use case
  serviceLocator.registerFactory(() => GetMyPseudo(serviceLocator()));

  // Bloc : on donne le use case au bloc pour qu'il gère l'état de la page
  serviceLocator.registerLazySingleton(
    () => DashboardBloc(getMyPseudo: serviceLocator()),
  );
}

void _initCodeBarre() {
  // Data Source
  serviceLocator.registerFactory<CodeBarreRemoteDataSource>(
    () => CodeBarreRemoteDataSourceImpl(client: serviceLocator()),
  );

  // Repository
  serviceLocator.registerFactory<AlimentRepository>(
    () => AlimentRepositoryImpl(serviceLocator()),
  );

  // UseCase getaAliment
  serviceLocator.registerFactory(() => GetAlimentByCode(serviceLocator()));
  // UseCase pour recuperer un aliment similaire
  serviceLocator.registerFactory(() => GetAlternativeProduct(serviceLocator()));

  // Bloc
  // Vu que c'est un scan, on utilise registerFactory (nouvel état à chaque ouverture)
  serviceLocator.registerFactory(
    () => ScanBloc(getAlimentByCode: serviceLocator()),
  );

  //Cubit pour l'alternative
  serviceLocator.registerFactory(
    () => AlternativeProductCubit(getAlternativeProduct: serviceLocator()),
  );
}

void _initStreak() {
  // Datasource
  serviceLocator.registerFactory<StreakRemoteDatasource>(
    () => StreakRemoteDatasource(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ), // Précise SupabaseClient
  );

  // Repository
  serviceLocator.registerFactory<StreakRepository>(
    () => StreakRepositoryImpl(serviceLocator<StreakRemoteDatasource>()),
  );

  // Use Case
  serviceLocator.registerFactory<WatchStreakUseCase>(
    () => WatchStreakUseCase(serviceLocator<StreakRepository>()),
  );
  serviceLocator.registerFactory<GetStreakUseCase>(
    () => GetStreakUseCase(streakRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<CalculerProgresUseCase>(
    () => CalculerProgresUseCase(serviceLocator<StreakRepository>()),
  );
  serviceLocator.registerFactory<RecupererStreakStepsUseCase>(
    () => RecupererStreakStepsUseCase(serviceLocator<StreakRepository>()),
  );
  serviceLocator.registerFactory(
    () => MarkStreakAsSeenUseCase(serviceLocator<StreakRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory<StreakBloc>(
    () => StreakBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
}

void _initActions() {
  // Datasource
  serviceLocator.registerLazySingleton<ActionRemoteDataSource>(
    () => ActionRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<ActionRepository>(
    () => ActionRepositoryImpl(serviceLocator<ActionRemoteDataSource>()),
  );

  // Use Cases
  serviceLocator.registerLazySingleton(
    () => GetActionsUseCase(serviceLocator<ActionRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => GetMyActiveActionsUseCase(serviceLocator<ActionRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => AddToMyActionsUseCase(serviceLocator<ActionRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => ValidateActionUseCase(serviceLocator<ActionRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => RemoveFromMyActionsUseCase(serviceLocator<ActionRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => GetMyHabitudesUseCase(serviceLocator<ActionRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => PromoteToHabitudeUseCase(serviceLocator<ActionRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => GetLimiteActionsFreqUseCase(repository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => EcarterActionUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => EcarterCategorieUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => EcarterTagUseCase(repository: serviceLocator()),
  );

  // Bloc
  serviceLocator.registerFactory(
    () => ActionsBloc(
      getActions: serviceLocator(),
      getMyActiveActions: serviceLocator(),
      addToMyActions: serviceLocator(),
      validateAction: serviceLocator(),
      removeFromMyActions: serviceLocator(),
      getMyHabitudes: serviceLocator(),
      promoteActionToHabitude: serviceLocator(),
      getLimiteActionsFreq: serviceLocator(),
      ecarterAction: serviceLocator(),
      ecarterCategorie: serviceLocator(),
      ecarterTag: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<HabitudeCubit>(
    () => HabitudeCubit(getMyHabitudesUseCase: serviceLocator()),
  );
}

void _initProfile() {
  // Repository
  serviceLocator.registerLazySingleton<ProfileBilanRepository>(
    () => ProfileBilanRepositoryImpl(serviceLocator<SupabaseClient>()),
  );

  // Use Case
  serviceLocator.registerLazySingleton(
    () =>
        GetQuestionsRestantesUseCase(serviceLocator<ProfileBilanRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory(
    () => ProfileBilanCubit(getQuestionsRestantesUseCase: serviceLocator()),
  );
}
