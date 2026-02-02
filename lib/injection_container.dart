import 'package:oikos/features/admin/data/repositories/community_impl.dart';
import 'package:oikos/features/admin/data/repositories/user_impl.dart';
import 'package:oikos/features/admin/domain/interfaces/co2_performance_rep.dart';
import 'package:oikos/features/admin/data/repositories/co2_performance_impl.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';
import 'package:oikos/features/admin/domain/interfaces/user_rep.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';
import 'package:oikos/features/admin/domain/use_cases/delete_community.dart';
import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/domain/use_cases/get_community_data.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_code.dart';
import 'package:oikos/features/admin/domain/use_cases/update_user.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setup() {
  
  //Clients
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //Repositories
  sl.registerLazySingleton<Co2PerformanceRep>(
    () => Co2PerformanceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<CommunityRep>(
    () => CommunityImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<UserRep>(() => UserImpl(sl<SupabaseClient>()));

  //UseCases
  sl.registerFactory(() => GetCo2Performance(sl<Co2PerformanceRep>()));
  sl.registerFactory(() => UpdateCommunityCode(sl<CommunityRep>()));
  sl.registerFactory(() => GetCommunityData(sl<CommunityRep>()));
  sl.registerFactory(() => UpdateUser(sl<UserRep>()));
  sl.registerFactory(() => CreateCommunity(sl<CommunityRep>()));
  sl.registerFactory(() => DeleteCommunity(sl<CommunityRep>()));
  
  
  //Bloc
  sl.registerFactory(() => Co2PerformanceBloc(sl<GetCo2Performance>()));
  sl.registerFactory(
    () => CommunityBloc(
      getCommunityData: sl<GetCommunityData>(),
      updateCommunityCode: sl<UpdateCommunityCode>(),
      updateUser: sl<UpdateUser>(),
      createCommunity: sl<CreateCommunity>(),
      deleteCommunity:sl<DeleteCommunity>()
    ),
  );
}
