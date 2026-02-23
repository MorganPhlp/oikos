import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/community_action_model.dart';

class CommunityRemoteDataSource {
  final SupabaseClient supabase;

  CommunityRemoteDataSource(this.supabase);

  // Catalogue des actions de base
  Future<List<CommunityActionModel>> getActions() async {
    final response = await supabase.from('actions').select();
    return (response as List).map((e) => CommunityActionModel.fromJson(e)).toList();
  }

  // Classement Utilisateurs
  Future<List<LeaderboardEntryModel>> getUserLeaderboard(String communityCode) async {
    final currentUserId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('vue_user_ranking')
        .select()
        .eq('code_communaute', communityCode)
        .order('total_xp', ascending: false);

    final list = response as List<dynamic>;
    return list.asMap().entries.map((entry) {
      final model = LeaderboardEntryModel.fromUserView(entry.value, currentUserId);
      return model.copyWith(rank: entry.key + 1);
    }).toList();
  }

  // Classement Communautés
  Future<List<LeaderboardEntryModel>> getCommunityLeaderboard(String entrepriseId, String myCommunityCode) async {
    try {
      final response = await supabase
          .from('vue_community_ranking')
          .select()
          .eq('entreprise_id', entrepriseId)
          .order('total_xp', ascending: false);

      final list = response as List<dynamic>;
      return list.asMap().entries.map((entry) {
        final model = LeaderboardEntryModel.fromCommunityView(entry.value, myCommunityCode);
        return model.copyWith(rank: entry.key + 1);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Détails d'une communauté (utilisé par les modals)
  Future<LeaderboardEntryModel?> getCommunityDetails(String communityCode) async {
    try {
      final response = await supabase
          .from('vue_community_ranking')
          .select()
          .eq('community_code', communityCode)
          .maybeSingle();

      if (response == null) return null;
      return LeaderboardEntryModel.fromCommunityView(response, communityCode);
    } catch (e) {
      return null;
    }
  }

  // Méthode qui manquait pour le profil
  Future<List<LeaderboardEntryModel>> getCommunityTopContributors(String communityCode) async {
    try {
      final response = await supabase
          .from('utilisateur')
          .select('id, pseudo, impact_score_xp, avatar_url')
          .eq('code_communaute', communityCode)
          .order('impact_score_xp', ascending: false)
          .limit(3);

      return (response as List).map((json) {
        return LeaderboardEntryModel(
          id: json['id'],
          label: "${json['pseudo'] ?? ''}".trim(),
          value: json['impact_score_xp'] ?? 0,
          rank: 0,
          isUser: true,
          isMe: false,
          avatarUrl: json['avatar_url'],
          actionsCount: 0,
          streakDays: 0,
          membersCount: 0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Arrosage manuel de la plante
  Future<void> waterPlant(String communityCode, int xpAmount) async {
    await supabase.rpc('water_plant', params: {
      'community_code_arg': communityCode,
      'xp_amount': xpAmount,
    });
  }

  // Actions communautaires actives (utilisé par la HomePage et le Sheet)
  Future<List<dynamic>> getActiveChallenges(String entrepriseId) async {
    final userId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('vue_actions_communautaires_actives') 
        .select()
        .eq('entreprise_id', entrepriseId)
        .order('date_fin', ascending: true);
    
    final participations = await supabase
        .from('action_communautaire_participation')
        .select('action_id')
        .eq('user_id', userId);

    final myJoinedIds = (participations as List).map((p) => p['action_id'].toString()).toSet();

    return (response as List).map((json) {
      return {
        ...json,
        'is_joined': myJoinedIds.contains(json['action_id'].toString()),
      };
    }).toList();
  }

  // Validation avec la logique des 60%
  Future<void> validateCommunityAction({
    required String instanceId,
    required String baseActionId,
    required String codeCommunaute,
    required int userXpGain,
    required int communityXpReward,
  }) async {
    final userId = supabase.auth.currentUser!.id;
      
    try {
      await supabase.from('action_communautaire_participation').insert({
        'action_id': instanceId,
        'user_id': userId,
        'code_communaute': codeCommunaute,
      });
    } catch (_) {}

    await supabase.rpc('add_xp_to_user', params: {
      'user_id_param': userId,
      'xp_amount': userXpGain,
    });

    // Déclenche le calcul des 60% côté serveur
    await supabase.rpc('check_and_reward_community_action', params: {
      'instance_id_param': instanceId,
      'community_code_param': codeCommunaute,
      'xp_reward': communityXpReward,
    });

    await supabase.from('realisation_actions').insert({
      'utilisateur_id': userId,
      'action_id': baseActionId,
      'date_realisation': DateTime.now().toIso8601String(),
      'xp_gagne': userXpGain,
      'co2_economise': 0.5,
    });

    await supabase.from('realisation_actions').insert({
      'utilisateur_id': userId,
      'action_id': baseActionId,
      'date_realisation': DateTime.now().toIso8601String(),
      'xp_gagne': userXpGain,
      'co2_economise': 0.5,
    });

    await supabase.from('utilisateur')
        .update({ 'actions_count': (await _getCurrentActions(userId)) + 1 })
        .eq('id', userId);
  }

  // Méthode helper pour récupérer le nombre d'actions actuel
  Future<int> _getCurrentActions(String userId) async {
    try {
      final res = await supabase
          .from('utilisateur')
          .select('actions_count')
          .eq('id', userId)
          .single();
      return (res['actions_count'] as num?)?.toInt() ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Création d'une action de groupe
  Future<void> createCommunityChallenge({
    required String entrepriseId,
    required String actionId,
    String? titrePersonnalise,
    required int daysDuration,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final dateFin = DateTime.now().add(Duration(days: daysDuration)).toIso8601String();

    await supabase.from('action_communautaire').insert({
      'entreprise_id': entrepriseId,
      'action_id': actionId,
      'titre_personnalise': titrePersonnalise,
      'date_fin': dateFin,
      'createur_id': userId,
    });
  }
}