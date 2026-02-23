import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/community_action_model.dart';
import '../models/defi_model.dart';

class CommunityRemoteDataSource {
  final SupabaseClient supabase;

  CommunityRemoteDataSource(this.supabase);

  // Récupère la liste des actions de la base de données
  Future<List<CommunityActionModel>> getActions() async {
    final response = await supabase.from('actions').select();
    return (response as List).map((e) => CommunityActionModel.fromJson(e)).toList();
  }

  // Récupère la liste des défis de la base de données
  Future<List<DefiModel>> getDefisCatalog(String entrepriseId) async {
    final response = await supabase
        .from('defis')
        .select()
        .eq('entreprise_id', entrepriseId);
    return (response as List).map((e) => DefiModel.fromJson(e)).toList();
  }

  // Récupère les défis spécifiques (table 'defis')
  Future<List<DefiModel>> getActiveDefis(String entrepriseId) async {
    final response = await supabase
        .from('defis')
        .select()
        .eq('entreprise_id', entrepriseId);
    
    return (response as List).map((json) => DefiModel.fromJson(json)).toList();
  }

  Future<void> respondToChallenge(String challengeId, bool accept) async {
    final nouveauStatut = accept ? 'ACTIF' : 'REFUSE';
    
    await supabase
        .from('defis_communautes')
        .update({
          'statut': nouveauStatut,
          'date_debut': accept ? DateTime.now().toIso8601String() : null,
        })
        .eq('id', challengeId);
  }

  // Récupère le classement des utilisateurs de la base de données
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

  // Récupère le classement des communautés de la base de données
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

  // Récupère le détail des communautés de la base de données 
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

  // Récupère les utilisateurs les plus actifs de la communauté
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

  // Récupère les informations sur les communautés adverses
  Future<List<LeaderboardEntryModel>> getAdversaryCommunities(String entrepriseId, String myCode) async {
    final response = await supabase
        .from('vue_community_ranking')
        .select()
        .eq('entreprise_id', entrepriseId)
        .neq('community_code', myCode); 

    return (response as List).map((json) => 
      LeaderboardEntryModel.fromCommunityView(json, myCode)
    ).toList();
  }

  // Fonction pour lancer un défi
  Future<void> proposeDuel({
    required String defiId,
    required String myCommunityCode,
    required String targetCommunityCode,
    required String entrepriseId,
    required int durationDays,
  }) async {
    await supabase.from('defis_communautes').insert({
      'defi_id': defiId,
      'entreprise_id': entrepriseId,
      'communaute_demandeur_code': myCommunityCode,
      'communaute_cible_code': targetCommunityCode,
      'is_global': false,
      'statut': 'VOTE_LANCEMENT',
      'date_expiration': DateTime.now().add(Duration(days: durationDays)).toIso8601String(),
    });
  }

  // Fonction de vote pour un défi
  Future<void> voteForDefiLaunch(String defiCommunauteId, String communityCode) async {
    final userId = supabase.auth.currentUser!.id;
    
    await supabase.from('votes_lancement_defi').insert({
      'defi_communaute_id': defiCommunauteId,
      'user_id': userId,
      'code_communaute': communityCode,
    });

    await supabase.rpc('check_defi_launch_threshold', params: {
      'defi_id_param': defiCommunauteId,
      'community_code_param': communityCode,
    });
  }

  // Fonction d'ajout d'XP à la communauté
  Future<void> waterPlant(String communityCode, int xpAmount) async {
    await supabase.rpc('water_plant', params: {
      'community_code_arg': communityCode,
      'xp_amount': xpAmount,
    });
  }

  // Récupère les actions communautaires actives de la base de données
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

  // Valide l'action communautaire et ajoute des XP à l'utilisateur et à la communauté concernés
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

    final currentActions = await _getCurrentActions(userId);
    await supabase.from('utilisateur')
        .update({ 'actions_count': currentActions + 1 })
        .eq('id', userId);
  }

  // Récupère les actions communautaires actives
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

  // Fonction de création d'une action communautaire
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

  // À ajouter dans community_remote_datasource.dart
  Future<List<dynamic>> getMyCommunityDefis(String communityCode) async {
    final userId = supabase.auth.currentUser!.id;

    // 1. Récupérer les défis où ma communauté est impliquée (demandeur ou cible)
    final response = await supabase
        .from('defis_communautes')
        .select('*, defis(titre, categorie_nom)')
        .or('communaute_demandeur_code.eq.$communityCode,communaute_cible_code.eq.$communityCode');

    // 2. Récupérer les votes pour compter la jauge et savoir si j'ai déjà voté
    final votesResponse = await supabase
        .from('votes_lancement_defi')
        .select('defi_communaute_id, user_id')
        .eq('code_communaute', communityCode);

    final List votes = votesResponse as List;

    // 3. On assemble tout pour le Dashboard
    return (response as List).map((json) {
      final defiCommunauteId = json['id'].toString();
      
      // Compte le nombre de votes
      final voteCount = votes.where((v) => v['defi_communaute_id'].toString() == defiCommunauteId).length;
      // Vérifie si moi j'ai voté
      final hasVoted = votes.any((v) => v['defi_communaute_id'].toString() == defiCommunauteId && v['user_id'].toString() == userId);

      return {
        ...json,
        'titre': json['defis'] != null ? json['defis']['titre'] : 'Défi',
        'participants_count': voteCount,
        'is_joined': hasVoted,
      };
    }).toList();
  }
}