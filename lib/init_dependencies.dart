import 'package:oikos/features/admin/data/repositories/community_impl.dart';
import 'package:oikos/features/admin/data/repositories/company_impl.dart';
import 'package:oikos/features/admin/data/repositories/logos_impl.dart';
import 'package:oikos/core/common/data/utilisateurs_impl.dart';
import 'package:oikos/features/admin/domain/interfaces/carbon_foot_print_rep.dart';
import 'package:oikos/features/admin/data/repositories/carbon_foot_print_impl.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';
import 'package:oikos/features/admin/domain/interfaces/company_rep.dart';
import 'package:oikos/features/admin/domain/interfaces/logos_rep.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';
import 'package:oikos/features/admin/domain/use_cases/anonymize_user.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';
import 'package:oikos/features/admin/domain/use_cases/delete_community.dart';
import 'package:oikos/features/admin/domain/use_cases/get_avatars.dart';
import 'package:oikos/features/admin/domain/use_cases/get_logos.dart';
import 'package:oikos/features/admin/domain/use_cases/get_company_info.dart';
import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/domain/use_cases/get_community_data.dart';
import 'package:oikos/features/admin/domain/use_cases/get_rankings.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_code.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_logo.dart';
import 'package:oikos/features/admin/domain/use_cases/update_company.dart';
import 'package:oikos/features/admin/domain/use_cases/update_user.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/users_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:oikos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:oikos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/usecases/current_user.dart';
import 'package:oikos/features/auth/domain/usecases/user_signin.dart';
import 'package:oikos/features/auth/domain/usecases/user_signup.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

void _initAdmin() {
  //Repositories
  serviceLocator.registerLazySingleton<CarbonFootPrintRep>(
    () => CarbonFootPrintImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<CommunityRep>(
    () => CommunityImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseExternal"),
    ),
  );
  serviceLocator.registerLazySingleton<UtilisateursRep>(
    () => UtilisateursImpl(
      serviceLocator<SupabaseClient>(instanceName: "supabaseExternal"),
    ),
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
    () => AnonymizeUser(serviceLocator<UtilisateursRep>()),
  );

  serviceLocator.registerFactory(
    () => GetRankings(
      repository: serviceLocator<CommunityRep>(),
      userRepository: serviceLocator<UtilisateursRep>(),
      carbonFootPrintRepository: serviceLocator<CarbonFootPrintRep>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetCarbonFootPrint(serviceLocator<CarbonFootPrintRep>()),
  );
  serviceLocator.registerFactory(
    () => UpdateCommunityCode(serviceLocator<CommunityRep>()),
  );
  serviceLocator.registerFactory(
    () => GetCommunityData(
      serviceLocator<CommunityRep>(),
      serviceLocator<UtilisateursRep>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateUser(serviceLocator<UtilisateursRep>()),
  );
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
  serviceLocator.registerFactory(
    () => RankingBloc(getRanking: serviceLocator<GetRankings>()),
  );
  serviceLocator.registerFactory(
    () => UsersBloc(
      getCommunityData: serviceLocator<GetCommunityData>(),
      anonymizeUser: serviceLocator<AnonymizeUser>(),
    ),
  );

}
