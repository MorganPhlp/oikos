import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/community_action_model.dart';

// Source de données distante pour les fonctionnalités de la communauté
class CommunityRemoteDataSource {
  final SupabaseClient supabase;

  CommunityRemoteDataSource(this.supabase);

  // On récupère les actions disponibles sur la base de données
  Future<List<CommunityActionModel>> getActions() async {
    final response = await supabase.from('actions').select(); // Table "actions"
    return (response as List).map((e) => CommunityActionModel.fromJson(e)).toList();
  }

// On récupère le classement des utilisateurs d'une communauté spécifique
Future<List<LeaderboardEntryModel>> getUserLeaderboard(String communityCode) async {
    final currentUserId = supabase.auth.currentUser!.id;
    
    final response = await supabase
        .from('vue_user_ranking') // Nom de la vue SQL pour le classement utilisateur
        .select()
        .eq('code_communaute', communityCode) // Filtre par communauté
        // On trie d'abord par XP, puis par actions pour le départage
        .order('total_xp', ascending: false) 
        .order('actions_count', ascending: false);

    final list = response as List<dynamic>;

    // Calcul du rang en fonction de la position dans la liste triée
    return list.asMap().entries.map((entry) {
      final index = entry.key;
      final json = entry.value;

      final model = LeaderboardEntryModel.fromUserView(json, currentUserId);

      return model.copyWith(rank: index + 1);
      
    }).toList();
  }

// On récupère le classement des communautés pour une entreprise spécifique
  Future<List<LeaderboardEntryModel>> getCommunityLeaderboard(String entrepriseId, String myCommunityCode) async {
    try {
      final response = await supabase
          .from('vue_community_ranking') // Nom de la vue SQL pour le classement communautaire
          .select()
          .eq('entreprise_id', entrepriseId) // Filtre par entreprise
          // On trie d'abord par XP, puis par actions pour le départage
          .order('total_xp', ascending: false)
          .order('total_actions', ascending: false);

      final list = response as List<dynamic>;

      // On transforme la liste et on calcule le rang
      return list.asMap().entries.map((entry) {
        final index = entry.key;
        final json = entry.value;

        final model = LeaderboardEntryModel.fromCommunityView(json, myCommunityCode);

        return model.copyWith(rank: index + 1);
      }).toList();

    } catch (e) {
      print("Erreur getCommunityLeaderboard: $e");
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  // Ajout des points d'expérience des utilisateurs à la plante communautaire
  Future<void> waterPlant(String communityCode, int xpAmount) async {
    await supabase.rpc('water_plant', params: {
      'community_code_arg': communityCode,
      'xp_amount': xpAmount,
    });
  }

  // On récupère les détails d'une communauté via la vue (pour avoir le nombre de membres "members_count")
  Future<LeaderboardEntryModel?> getCommunityDetails(String communityCode) async {
    try {
      final response = await supabase
          .from('vue_community_ranking') // Nom de la vue SQL pour le classement communautaire
          .select()
          .eq('community_code', communityCode) // Filtre par code de communauté
          .maybeSingle(); // On récupère un seul résultat

      if (response == null) return null;

      return LeaderboardEntryModel.fromCommunityView(response, communityCode);
    } catch (e) {
      print("Erreur getCommunityDetails: $e");
      return null; // Retourne null en cas d'erreur
    }
  }
  
  // On récupère les 3 meilleurs contributeurs d'une communauté spécifique pour l'affichage dans le profil de la communauté
  Future<List<LeaderboardEntryModel>> getCommunityTopContributors(String communityCode) async {
    try {
      final response = await supabase
          .from('utilisateur') // Table des utilisateurs
          .select('id, pseudo, impact_score_xp, avatar_url') // On sélectionne les données qu'on souhaite afficher
          .eq('code_communaute', communityCode)              // Filtre par code de communauté
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
      print("Erreur getCommunityTopContributors: $e");
      return [];
    }
  }

  // Lancer un nouveau défi communautaire
  Future<void> createCommunityChallenge({
    required String entrepriseId,
    required String actionId,
    String? titrePersonnalise,
    required int daysDuration,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final dateFin = DateTime.now().add(Duration(days: daysDuration)).toIso8601String();

      await supabase.from('defi_communautaire').insert({
        'entreprise_id': entrepriseId,
        'action_id': actionId,
        'titre_personnalise': titrePersonnalise,
        'date_fin': dateFin,
        'createur_id': userId,
      });
    } catch (e) {
      print("Erreur createCommunityChallenge: $e");
      rethrow;
    }
  }

  // Récupérer les défis en cours
  Future<List<dynamic>> getActiveChallenges(String entrepriseId) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from('vue_defis_actifs') 
          .select()
          .eq('entreprise_id', entrepriseId)
          .order('date_fin', ascending: true);
      
      final participations = await supabase
          .from('defi_participation')
          .select('defi_id')
          .eq('user_id', userId);

      final myJoinedIds = (participations as List).map((p) => p['defi_id'].toString()).toSet();

      return (response as List).map((json) {
        final defiId = json['defi_id'].toString();
        return {
          ...json,
          'is_joined': myJoinedIds.contains(defiId),
        };
      }).toList();
    } catch (e) {
      print("Erreur getActiveChallenges: $e");
      return [];
    }
  }

  // Rejoindre un défi et le valider
  Future<void> joinAndValidateChallenge({
    required String defiId, 
    required String codeCommunaute, 
    required int xpGain, 
    required String actionId,
    required double co2Saved,
  }) async {
    final userId = supabase.auth.currentUser!.id;
      
    // Inscription au défi collectif
    try {
      await supabase.from('defi_participation').insert({
        'defi_id': defiId,
        'user_id': userId,
        'code_communaute': codeCommunaute,
      });
    } catch (e) {
      // Si on est déjà inscrit, on peut quand même vouloir valider l'action
      print("Déjà inscrit au défi ou erreur: $e");
    }

    // Ajout des points d'XP au profil utilisateur
    await supabase.rpc('add_xp_to_user', params: {
      'user_id_param': userId,
      'xp_amount': xpGain,
    });

    // Insertion dans l'historique
    try {
      await supabase.from('realisation_actions').insert({
        'utilisateur_id': userId,
        'action_id': actionId,
        'date_realisation': DateTime.now().toIso8601String(), // Date du jour
        'xp_gagne': xpGain,           // Points gagnés
        'co2_economise': co2Saved,    // CO2 économisé
      });
    } catch (e) {
      print("Erreur insertion realisation_actions: $e");
      throw Exception("Erreur lors de l'enregistrement de l'action: $e");
    }
  }
}