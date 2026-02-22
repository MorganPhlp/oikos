import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/features/home/data/models/home_stats_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeStatsRemoteDataSource {
  Future<HomeStatsModel> fetchHomeStats(String userId);
}

class HomeStatsRemoteDataSourceImpl implements HomeStatsRemoteDataSource {
  final SupabaseClient supabaseClient;
  HomeStatsRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<HomeStatsModel> fetchHomeStats(String userId) async {
    try {
      final response = await supabaseClient
          .from('vue_home_stats')
          .select()
          .eq('utilisateur_id', userId)
          .single();
      return HomeStatsModel.fromJson(response);
    } catch (e) {
      throw ServerException('Erreur lors du chargement des statistiques : $e');
    }
  }
}
