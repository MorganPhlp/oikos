import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/community_action_model.dart';

// Source de données distante pour les fonctionnalités communautaires
class CommunityRemoteDataSource {
  final SupabaseClient supabase;

  CommunityRemoteDataSource(this.supabase);

  // Récupérer les actions disponibles
  Future<List<CommunityActionModel>> getActions() async {
    final response = await supabase.from('actions').select();
    return (response as List).map((e) => CommunityActionModel.fromJson(e)).toList();
  }

  // Récupérer le classement individuel des utilisateurs
  Future<List<LeaderboardEntryModel>> getUserLeaderboard(String communityCode) async {
    final currentUserId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('vue_user_ranking')
        .select()
        .eq('code_communaute', communityCode)
        .order('rank', ascending: true);
    return (response as List).map((e) => LeaderboardEntryModel.fromUserView(e, currentUserId)).toList();
  }

  // Récupérer le classement des communautés
  Future<List<LeaderboardEntryModel>> getCommunityLeaderboard(String entrepriseId, String myCommunityCode) async {
    final response = await supabase
        .from('vue_community_ranking')
        .select()
        .eq('entreprise_id', entrepriseId)
        .order('rank', ascending: true);
    return (response as List).map((e) => LeaderboardEntryModel.fromCommunityView(e, myCommunityCode)).toList();
  }

  // Ajout des points d'expérience à la plante communautaire
  Future<void> waterPlant(String communityCode, int xpAmount) async {
    await supabase.rpc('water_plant', params: {
      'community_code_arg': communityCode,
      'xp_amount': xpAmount,
    });
  }
}