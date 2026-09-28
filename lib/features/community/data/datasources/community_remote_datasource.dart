import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/leaderboard_entry_model.dart';
import '../../domain/models/community_action_model.dart';
import '../../domain/models/defi_model.dart';

import '../../domain/repositories/community_repository.dart';

class CommunityRemoteDataSource implements CommunityRepository {
  final SupabaseClient supabase;

  CommunityRemoteDataSource(this.supabase);

  /// Récupère la liste des actions de base
  @override
  Future<List<CommunityActionModel>> getActions() async {
    final response = await supabase.from('actions').select();
    return (response as List)
        .map((e) => CommunityActionModel.fromJson(e))
        .toList();
  }

  /// Récupère l'ensemble des défis pour l'entreprise [entrepriseId]
  @override
  Future<List<DefiModel>> getDefisCatalog(String entrepriseId) async {
    final response = await supabase
        .from('defis')
        .select()
        .eq('entreprise_id', entrepriseId);
    return (response as List).map((e) => DefiModel.fromJson(e)).toList();
  }

  /// Récupère les défis actifs de l'entreprise [entrepriseId]
  @override
  Future<List<DefiModel>> getActiveDefis(String entrepriseId) async {
    final rows = await supabase
        .from('defis_communautes')
        .select('defis(*)')
        .eq('entreprise_id', entrepriseId)
        .eq('statut', 'ACTIF')
        .gt('date_expiration', DateTime.now().toUtc().toIso8601String());
    return rows
        .map(
          (row) => DefiModel.fromJson(Map<String, dynamic>.from(row['defis'])),
        )
        .toList();
  }

  /// Vérifie si l'utilisateur a déjà validé le défi [defiId] spécifique aujourd'hui
  @override
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
  @override
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
  @override
  Future<List<LeaderboardEntryModel>> getCommunityTopContributors(
    String communityCode,
  ) async {
    final users = await getUserLeaderboard(communityCode);
    return users.take(3).toList();
  }

  /// Enregistre une validation de l'action [defiId] et attribue [xpGain] XP
  /// à la communauté [communityCode]
  @override
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
  @override
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
  @override
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
  @override
  Future<void> respondToChallenge(String challengeId, bool accept) async {
    final nouveauStatut = accept ? 'ACTIF' : 'REFUSE';

    await supabase
        .from('defis_communautes')
        .update({'statut': nouveauStatut})
        .eq('id', challengeId);
  }

  /// Récupère les défis de la communauté [communauteCode] pour le Dashboard (Votes en cours + Infos titres)
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
  Future<void> validateCollectiveAction({
    required String instanceId,
    required String baseActionId,
    required String communityCode,
    required int xpGain,
  }) async {
    await supabase.rpc(
      'validate_collective_action',
      params: {'instance_id': instanceId},
    );
  }

  @override
  Future<Map<String, dynamic>?> getMyMembership() async {
    final id = supabase.auth.currentUser?.id;
    if (id == null) throw StateError('Utilisateur non connecté');
    return supabase
        .from('utilisateur')
        .select('code_communaute,entreprise_id')
        .eq('id', id)
        .maybeSingle();
  }

  @override
  Future<int> getRequiredVotes(String communityCode) async {
    final members = await getUserLeaderboard(communityCode);
    final required = (members.length * 0.6).ceil();
    return required < 1 ? 1 : required;
  }

  @override
  Future<List<String>> getActiveActionIds(String companyId) async {
    final rows = await supabase
        .from('action_communautaire')
        .select('action_id')
        .eq('entreprise_id', companyId)
        .gt('date_fin', DateTime.now().toUtc().toIso8601String());
    return rows.map((row) => row['action_id'].toString()).toList();
  }

  @override
  Future<Map<String, dynamic>?> getExistingDuel(String from, String to) async {
    return supabase
        .from('defis_communautes')
        .select('*,defis(titre)')
        .or(
          'and(communaute_demandeur_code.eq.$from,communaute_cible_code.eq.$to),and(communaute_demandeur_code.eq.$to,communaute_cible_code.eq.$from)',
        )
        .inFilter('statut', ['VOTE_LANCEMENT', 'EN_ATTENTE_CIBLE', 'ACTIF'])
        .gt('date_expiration', DateTime.now().toUtc().toIso8601String())
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  @override
  Future<void> proposeRandomDuel({
    required String targetCommunity,
    required String category,
    required int durationDays,
  }) async {
    await supabase.rpc(
      'propose_random_duel',
      params: {
        'target_community': targetCommunity,
        'category': category,
        'duration_days': durationDays,
      },
    );
  }
}
