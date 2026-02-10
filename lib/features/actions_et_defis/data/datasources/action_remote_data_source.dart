import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/action_model.dart';

class ActionRemoteDataSourceImpl {
  final SupabaseClient supabaseClient;

  ActionRemoteDataSourceImpl(this.supabaseClient);

  Future<List<ActionModel>> fetchActions(String userId) async {
    try {
      // 1. Récupérer les préférences
      final prefsResponse = await supabaseClient
          .from('utilisateur_categorie_preference')
          .select('categorie_nom')
          .eq('utilisateur_id', userId);

      final List<String> myCategories = (prefsResponse as List)
          .map((e) => e['categorie_nom'] as String)
          .toList();

      List<dynamic> data;

      // 2. Récupérer les actions
      if (myCategories.isNotEmpty) {
        // ✅ CORRECTION ICI : On utilise .filter() au lieu de .in_()
        // Cela dit à Supabase : "Filtre où 'categorie_nom' est 'dans' la liste myCategories"
        data = await supabaseClient
            .from('actions')
            .select()
            .filter('categorie_nom', 'in', myCategories);
      } else {
        // Sinon on prend tout
        data = await supabaseClient
            .from('actions')
            .select();
      }

      return data.map((json) => ActionModel.fromJson(json)).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Erreur Fetch Actions: $e");
      return [];
    }
  }
  // Ajoute ça en dessous de fetchActions

  Future<List<ActionModel>> fetchMyChallenges(String userId) async {
    try {
      // On demande les défis ET on joint la table 'actions' pour avoir les détails (titre, icon...)
      final response = await supabaseClient
          .from('defis_personnels')
          .select('*, actions(*)') // Le select magique pour faire la jointure
          .eq('utilisateur_id', userId);

      final data = response as List<dynamic>;

      // On transforme ça en liste d'Actions pour l'affichage
      return data.map((json) {
        final actionJson = json['actions']; // On récupère l'objet action imbriqué
        // On peut ajouter la fréquence si tu veux l'afficher, mais restons simple
        return ActionModel.fromJson(actionJson);
      }).toList();
    } catch (e) {
      print("Erreur chargement défis: $e");
      return [];
    }
  }

  Future<void> joinChallenge(String userId, String actionId, String frequence) async {
    // 1. VÉRIFIER SI DÉJÀ PRÉSENT (Anti-Doublon)
    final existingChallenge = await supabaseClient
        .from('defis_personnels')
        .select()
        .eq('utilisateur_id', userId)
        .eq('action_id', actionId)
        .eq('statut', 'actif'); // On regarde seulement les actifs

    if ((existingChallenge as List).isNotEmpty) {
      throw Exception("ALREADY_JOINED"); // On lance une erreur spécifique
    }

    // 2. VÉRIFIER LA LIMITE DE 5
    final activeChallenges = await supabaseClient
        .from('defis_personnels')
        .select()
        .eq('utilisateur_id', userId)
        .eq('statut', 'actif');

    if ((activeChallenges as List).length >= 5) {
      throw Exception("LIMIT_REACHED");
    }

    // 3. SI TOUT EST OK, ON INSÈRE
    await supabaseClient.from('defis_personnels').insert({
      'utilisateur_id': userId,
      'action_id': actionId,
      'frequence': frequence,
      'statut': 'actif'
    });
  }

  Future<void> validateAction(String userId, String actionId, int xp, double co2) async {
    await supabaseClient.from('realisation_actions').insert({
      'utilisateur_id': userId,
      'action_id': actionId,
      'xp_gagne': xp,
      'co2_economise': co2,
      'date_realisation': DateTime.now().toIso8601String(),
    });

    // Update User
    final userRes = await supabaseClient
        .from('utilisateur')
        .select('impact_score_xp, co2_economise_total')
        .eq('id', userId)
        .single();

    int currentXp = (userRes['impact_score_xp'] as num?)?.toInt() ?? 0;
    double currentCo2 = (userRes['co2_economise_total'] as num?)?.toDouble() ?? 0.0;

    await supabaseClient.from('utilisateur').update({
      'impact_score_xp': currentXp + xp,
      'co2_economise_total': currentCo2 + co2
    }).eq('id', userId);
  }
  // Supprimer un défi (Arrêter l'action)
  Future<void> removeChallenge(String userId, String actionId) async {
    await supabaseClient
        .from('defis_personnels')
        .delete()
        .eq('utilisateur_id', userId)
        .eq('action_id', actionId);
    // On supprime uniquement l'engagement, pas l'historique des points !
  }
}