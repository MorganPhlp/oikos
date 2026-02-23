import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/community_action_model.dart';
import '../models/defi_model.dart';

class CommunityRemoteDataSource {
  final SupabaseClient supabase;

  CommunityRemoteDataSource(this.supabase);

  /// Récupère la liste des actions de base
  Future<List<CommunityActionModel>> getActions() async {
    final response = await supabase.from('actions').select();
    return (response as List)
        .map((e) => CommunityActionModel.fromJson(e))
        .toList();
  }

  /// Récupère l'ensemble des défis pour l'entreprise [entrepriseId]
  Future<List<DefiModel>> getDefisCatalog(String entrepriseId) async {
    final response = await supabase
        .from('defis')
        .select()
        .eq('entreprise_id', entrepriseId);
    return (response as List).map((e) => DefiModel.fromJson(e)).toList();
  }

  /// Récupère les défis actifs de l'entreprise [entrepriseId]
  Future<List<DefiModel>> getActiveDefis(String entrepriseId) async {
    final response = await supabase
        .from('defis')
        .select()
        .eq('entreprise_id', entrepriseId);

    return (response as List).map((json) => DefiModel.fromJson(json)).toList();
  }

  /// Vérifie si l'utilisateur a déjà validé le défi [defiId] spécifique aujourd'hui
  Future<bool> checkIfDefiValidatedToday(String defiId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final now = DateTime.now();
      final startOfDay = DateTime(
        now.year,
        now.month,
        now.day,
      ).toIso8601String();

      final response = await supabase
          .from('validations_defis')
          .select('id')
          .eq('defi_id', defiId)
          .eq('user_id', userId)
          .gte('created_at', startOfDay)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Fonction de création d'une action [actionId] communautaire [titrePersonnalise]
  /// pour l'entreprise [entrepriseId] d'une durée  de [daysDuration] jours
  Future<void> createCommunityChallenge({
    required String entrepriseId,
    required String actionId,
    String? titrePersonnalise,
    required int daysDuration,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final dateFin = DateTime.now()
        .add(Duration(days: daysDuration))
        .toIso8601String();

    await supabase.from('action_communautaire').insert({
      'entreprise_id': entrepriseId,
      'action_id': actionId, //
      'titre_personnalise': titrePersonnalise,
      'date_fin': dateFin,
      'createur_id': userId,
    });
  }

  /// Récupère les utilisateurs les plus actifs de la communauté [communityCode]
  Future<List<LeaderboardEntryModel>> getCommunityTopContributors(
    String communityCode,
  ) async {
    try {
      final response = await supabase
          .from('utilisateur')
          .select(
            'id, pseudo, impact_score_xp, avatar_url, actions_count, streak_days',
          )
          .eq('code_communaute', communityCode)
          .order('impact_score_xp', ascending: false)
          .limit(3);

      return (response as List).map((json) {
        return LeaderboardEntryModel(
          id: json['id'],
          label: "${json['pseudo'] ?? ''}".trim(),
          value: (json['impact_score_xp'] as num?)?.toInt() ?? 0,
          rank: 0,
          isUser: true,
          isMe: json['id'] == supabase.auth.currentUser?.id,
          avatarUrl: json['avatar_url'],
          actionsCount: json['actions_count'],
          streakDays: json['streak_days'],
          membersCount: 0,
        );
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des contributeurs : $e");
      return [];
    }
  }

  /// Enregistre une validation de l'action [defiId] et attribue [xpGain] XP
  /// à la communauté [communityCode]
  Future<void> validateDefiAction({
    required String defiId,
    required String communityCode,
    required int xpGain,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("Utilisateur non authentifié");

    // Insertion dans validations_defis
    await supabase.from('validations_defis').insert({
      'defi_id': defiId,
      'user_id': userId,
      'code_communaute': communityCode,
      'xp_gain': xpGain,
    });
  }

  /// Propose un défi [defiId] entre deux communautés [myCommunityCode] et [targetCommunityCode]
  /// de l'entreprise [entrepriseId] pour une durée de [durationDays] jours (Statut: VOTE_LANCEMENT)
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
      'date_expiration': DateTime.now()
          .add(Duration(days: durationDays))
          .toIso8601String(),
    });
  }

  /// Enregistre un vote pour lancer le défi [defiCommunauteId]
  /// parmi la communauté [communityCode] et vérifie le seuil (60% de votants)
  Future<void> voteForDefiLaunch(
    String defiCommunauteId,
    String communityCode,
  ) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase.from('votes_lancement_defi').insert({
      'defi_communaute_id': defiCommunauteId,
      'user_id': userId,
      'code_communaute': communityCode,
    });

    await supabase.rpc(
      'check_defi_launch_threshold',
      params: {
        'defi_id_param': defiCommunauteId,
        'community_code_param': communityCode,
      },
    );
  }

  /// Réponse [accept] de la communauté cible (Accepter ou Refuser) pour le défi [challengeId]
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

  /// Récupère les défis de la communauté [communauteCode] pour le Dashboard (Votes en cours + Infos titres)
  Future<List<dynamic>> getMyCommunityDefis(String communauteCode) async {
    final userId = supabase.auth.currentUser?.id;

    final response = await supabase
        .from('defis_communautes')
        .select('*, defis(titre, categorie_nom)')
        .or(
          'communaute_demandeur_code.eq.$communauteCode,communaute_cible_code.eq.$communauteCode',
        );

    final votesResponse = await supabase
        .from('votes_lancement_defi')
        .select('defi_communaute_id, user_id')
        .eq('code_communaute', communauteCode);

    final List votes = votesResponse as List;

    return (response as List).map((json) {
      final defiCommunauteId = json['id'].toString();
      final voteCount = votes
          .where((v) => v['defi_communaute_id'].toString() == defiCommunauteId)
          .length;
      final hasVoted = votes.any(
        (v) =>
            v['defi_communaute_id'].toString() == defiCommunauteId &&
            v['user_id'].toString() == userId,
      );

      return {
        ...json,
        'titre': json['defis'] != null ? json['defis']['titre'] : 'Défi',
        'participants_count': voteCount,
        'is_joined': hasVoted,
      };
    }).toList();
  }

  /// Récupère le classement des utilisateurs de la communauté [communauteCode]
  Future<List<LeaderboardEntryModel>> getUserLeaderboard(
    String communauteCode,
  ) async {
    final currentUserId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('vue_user_ranking')
        .select()
        .eq('code_communaute', communauteCode)
        .order('total_xp', ascending: false);

    final list = response as List<dynamic>;
    return list.asMap().entries.map((entry) {
      final model = LeaderboardEntryModel.fromUserView(
        entry.value,
        currentUserId,
      );
      return model.copyWith(rank: entry.key + 1);
    }).toList();
  }

  /// Récupère le classement des communautés de l'entreprise [entrepriseId]
  Future<List<LeaderboardEntryModel>> getCommunityLeaderboard(
    String entrepriseId,
    String myCommunityCode,
  ) async {
    try {
      final response = await supabase
          .from('vue_community_ranking')
          .select()
          .eq('entreprise_id', entrepriseId)
          .order('total_xp', ascending: false);

      final list = response as List<dynamic>;
      return list.asMap().entries.map((entry) {
        final json = Map<String, dynamic>.from(entry.value);

        // Conversion du logo_url en URL publique si disponible
        final logoPath = json['logo_url'] as String?;
        if (logoPath != null && logoPath.isNotEmpty) {
          json['logo_url'] = supabase.storage
              .from('logos')
              .getPublicUrl(logoPath);
        }

        final model = LeaderboardEntryModel.fromCommunityView(
          json,
          myCommunityCode,
        );
        return model.copyWith(rank: entry.key + 1);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Récupère les détails liés à la communauté [communauteCode]
  Future<LeaderboardEntryModel?> getCommunityDetails(
    String communauteCode,
  ) async {
    try {
      final response = await supabase
          .from('vue_community_ranking')
          .select()
          .eq('community_code', communauteCode)
          .maybeSingle();

      if (response == null) return null;

      // Conversion du logo_url en URL publique si disponible
      final json = Map<String, dynamic>.from(response);
      final logoPath = json['logo_url'] as String?;
      if (logoPath != null && logoPath.isNotEmpty) {
        json['logo_url'] = supabase.storage
            .from('logos')
            .getPublicUrl(logoPath);
      }

      return LeaderboardEntryModel.fromCommunityView(json, communauteCode);
    } catch (e) {
      return null;
    }
  }

  /// Récupère les communautés adverses parmi l'netreprise [entrepriseId] à celle de l'utilisateur connecté [myCode]
  Future<List<LeaderboardEntryModel>> getAdversaryCommunities(
    String entrepriseId,
    String myCode,
  ) async {
    final response = await supabase
        .from('vue_community_ranking')
        .select()
        .eq('entreprise_id', entrepriseId)
        .neq('community_code', myCode);

    return (response as List).map((item) {
      final json = Map<String, dynamic>.from(item);

      // Conversion du logo_url en URL publique si disponible
      final logoPath = json['logo_url'] as String?;
      if (logoPath != null && logoPath.isNotEmpty) {
        json['logo_url'] = supabase.storage
            .from('logos')
            .getPublicUrl(logoPath);
      }

      return LeaderboardEntryModel.fromCommunityView(json, myCode);
    }).toList();
  }

  /// Récupère les défis actifs de l'entreprise [entrepriseId]
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

    final myJoinedIds = (participations as List)
        .map((p) => p['action_id'].toString())
        .toSet();

    return (response as List).map((json) {
      return {
        ...json,
        'is_joined': myJoinedIds.contains(json['action_id'].toString()),
      };
    }).toList();
  }

  /// Valide la participation à une action collective et met à jour l'historique personnel
  Future<void> validateCollectiveAction({
    required String instanceId,
    required String baseActionId,
    required String communityCode,
    required int xpGain,
  }) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase.from('action_communautaire_participation').insert({
      'action_id': instanceId,
      'user_id': userId,
      'code_communaute': communityCode,
    });

    /// Ajout des XP à la communauté uniquement
    await waterPlant(communityCode, xpGain);

    final currentCount = await _getUserActionsCount(userId);
    await supabase
        .from('utilisateur')
        .update({'actions_count': currentCount + 1})
        .eq('id', userId);
  }

  ///
  Future<int> _getUserActionsCount(String userId) async {
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

  /// Ajoute [xpAmount] XP à la communauté [communauteCode]
  Future<void> waterPlant(String communauteCode, int xpAmount) async {
    await supabase.rpc(
      'water_plant',
      params: {'community_code_arg': communauteCode, 'xp_amount': xpAmount},
    );
  }
}
