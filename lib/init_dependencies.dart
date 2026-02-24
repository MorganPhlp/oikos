import 'package:oikos/features/admin/data/repositories/community_impl.dart';
import 'package:oikos/features/admin/data/repositories/company_impl.dart';
import 'package:oikos/features/admin/data/repositories/logos_impl.dart';
import 'package:oikos/features/admin/data/repositories/user_impl.dart';
import 'package:oikos/features/admin/domain/repositories/carbon_foot_print_rep.dart';
import 'package:oikos/features/admin/data/repositories/carbon_foot_print.dart';
import 'package:oikos/features/admin/domain/repositories/community_rep.dart';
import 'package:oikos/features/admin/domain/repositories/company_rep.dart';
import 'package:oikos/features/admin/domain/repositories/logos_rep.dart';
import 'package:oikos/features/admin/domain/repositories/user_rep.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';
import 'package:oikos/features/admin/domain/use_cases/delete_community.dart';
import 'package:oikos/features/admin/domain/use_cases/get_avatars.dart';
import 'package:oikos/features/admin/domain/use_cases/get_logos.dart';
import 'package:oikos/features/admin/domain/use_cases/get_company_info.dart';
import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/domain/use_cases/get_community_data.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_code.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_logo.dart';
import 'package:oikos/features/admin/domain/use_cases/update_company.dart';
import 'package:oikos/features/admin/domain/use_cases/update_user.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:oikos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:oikos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/usecases/current_user.dart';
import 'package:oikos/features/auth/domain/usecases/user_signin.dart';
import 'package:oikos/features/auth/domain/usecases/user_signup.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/bilanCarbone/data/datasources/publicodes_service.dart'
    if (dart.library.html) 'package:oikos/features/bilanCarbone/data/datasources/publicodes_service_web.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';
import 'package:oikos/features/dashboard/data/datasources/home_remote_data_source.dart';
import 'package:oikos/features/dashboard/data/repositories/home_repository_impl.dart';
import 'package:oikos/features/dashboard/domain/repository/home_repository.dart';
import 'package:oikos/features/dashboard/domain/usecases/get_my_profile.dart';
import 'package:oikos/features/dashboard/presentation/bloc/home_bloc.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/secrets/app_secrets.dart';
import 'features/auth/domain/usecases/validate_email_password.dart';
import 'features/auth/domain/usecases/validate_pseudo.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Initialisation de l'instance GLOBALE (Externe)
  // C'est celle qui gérera l'Auth, le Storage, etc. automatiquement dans l'app
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  final externalClient = Supabase.instance.client;

  // 2. Création manuelle du client LOCAL
  // On n'appelle PAS Supabase.initialize ici.
  final localClient = SupabaseClient(
    AppSecrets.supabaseLocalUrl,
    AppSecrets.supabaseLocalAnonKey,
  );

  // Enregistrement dans GetIt
  serviceLocator.registerLazySingleton<SupabaseClient>(
    () => externalClient,
    instanceName: "supabaseExternal",
  );

  serviceLocator.registerLazySingleton<SupabaseClient>(
    () => localClient,
    instanceName: "supabaseLocal",
  );

  // Par défaut, on donne l'externe
  serviceLocator.registerLazySingleton<SupabaseClient>(() => externalClient);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // Then initialize auth and bilan after Supabase is ready
  _initAuth();
  _initBilan();
  _initHome();
  _initAdmin();
}

void _initAuth() {
  // Data source
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(
        instanceName: "supabaseExternal",
      ),
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
      getCompanyInfo: serviceLocator(),
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
    () => QuestionRepositoryImpl(
      supabaseClient: serviceLocator(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<ReponseRepository>(
    () => ReponseRepositoryImpl(
      supabaseClient: serviceLocator(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<BilanSessionRepository>(
    () => BilanSessionRepositoryImpl(
      supabaseClient: serviceLocator(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<CarboneEquivalentRepository>(
    () => CarboneEquivalentRepositoryImpl(
      supabaseClient: serviceLocator(instanceName: "supabaseExternal"),
    ),
  );

  // ==========================================================
  // DOMAINE (Services & Use Cases)
  // ==========================================================
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
    () => GetProchaineQuestionUseCase(applicabilityChecker: serviceLocator()),
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
    ),
  );
}

void _initHome() {
  // Data source
  serviceLocator.registerFactory<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repository
  serviceLocator.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(serviceLocator<HomeRemoteDataSource>()),
  );

  // Use case
  serviceLocator.registerFactory(
    () => GetMyPseudo(serviceLocator<HomeRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory(() => HomeBloc(getMyPseudo: serviceLocator()));
}

void _initAdmin() {
  //Repositories
  serviceLocator.registerLazySingleton<CarbonFootPrintRep>(
    () => CarbonFootPrintImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseLocal"),
    ),
  );
  serviceLocator.registerLazySingleton<CommunityRep>(
    () => CommunityImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<UserRep>(
    () =>
        UserImpl(serviceLocator<SupabaseClient>(instanceName: "supabaseExternal")),
  );
  serviceLocator.registerLazySingleton<CompanyRep>(
    () => CompanyImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<LogosRep>(
    () => LogosImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseExternal"),
    ),
  );

  //UseCases
  serviceLocator.registerFactory(
    () => GetCarbonFootPrint(serviceLocator<CarbonFootPrintRep>()),
  );
  serviceLocator.registerFactory(
    () => UpdateCommunityCode(serviceLocator<CommunityRep>()),
  );
  serviceLocator.registerFactory(
    () => GetCommunityData(serviceLocator<CommunityRep>()),
  );
  serviceLocator.registerFactory(() => UpdateUser(serviceLocator<UserRep>()));
  serviceLocator.registerFactory(
    () => CreateCommunity(serviceLocator<CommunityRep>()),
  );
  serviceLocator.registerFactory(
    () => DeleteCommunity(serviceLocator<CommunityRep>()),
  );
  serviceLocator.registerFactory(
    () => GetCompanyInfo(serviceLocator<CompanyRep>()),
  );
  serviceLocator.registerFactory(() => GetLogos(serviceLocator<LogosRep>()));
  serviceLocator.registerFactory(
    () => UpdateCommunityLogo(serviceLocator<CommunityRep>()),
  );
  serviceLocator.registerFactory(() => GetAvatars(serviceLocator<LogosRep>()));

  serviceLocator.registerFactory(
    () => UpdateCompany(serviceLocator<CompanyRep>()),
  );

  //Bloc
  serviceLocator.registerFactory(
    () => CarbonFootPrintBloc(serviceLocator<GetCarbonFootPrint>()),
  );
  serviceLocator.registerFactory(
    () => CommunityBloc(
      getCommunityData: serviceLocator<GetCommunityData>(),
      updateCommunityCode: serviceLocator<UpdateCommunityCode>(),
      updateUser: serviceLocator<UpdateUser>(),
      createCommunity: serviceLocator<CreateCommunity>(),
      deleteCommunity: serviceLocator<DeleteCommunity>(),
      getLogos: serviceLocator<GetLogos>(),
      updateCommunityLogo: serviceLocator<UpdateCommunityLogo>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ProfileBloc(
      updateUser: serviceLocator<UpdateUser>(),
      getCompanyInfo: serviceLocator<GetCompanyInfo>(),
      updateCompanyInfo: serviceLocator<UpdateCompany>(),
      getAvatars: serviceLocator<GetAvatars>(),
      getLogos: serviceLocator<GetLogos>(),
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );
}
