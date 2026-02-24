import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/action_model.dart';

class ActionRemoteDataSourceImpl {
  final SupabaseClient supabaseClient;

  ActionRemoteDataSourceImpl(this.supabaseClient);

  // --- 1. CATALOGUE (Affiche les actions que l'utilisateur n'a pas encore prises) ---
  Future<List<ActionModel>> fetchActions(String userId) async {
    try {
      // Récupère les catégories préférées de l'utilisateur
      final prefsResponse = await supabaseClient.from('utilisateur_categorie_preference').select('categorie_nom').eq('utilisateur_id', userId);
      final List<String> myCategories = (prefsResponse as List).map((e) => e['categorie_nom'] as String).toList();

      // Liste les actions que l'utilisateur a déjà en cours
      final myActiveActions = await supabaseClient.from('actions_en_cours').select('action_id').eq('utilisateur_id', userId).eq('est_actif', true);
      final Set<String> activeIds = (myActiveActions as List).map((e) => e['action_id'].toString()).toSet();

      // Récupère la liste complète des actions du catalogue
      List<dynamic> data;
      if (myCategories.isNotEmpty) {
        // Filtrer par catégorie si l'utilisateur en a choisi
        data = await supabaseClient.from('actions').select().filter('categorie_nom', 'in', myCategories);
      } else {
        // Sinon, prendre tout le catalogue
        data = await supabaseClient.from('actions').select();
      }

      // Filtre : on ne garde que les actions que l'utilisateur n'a PAS encore activées
      final filteredData = data.where((json) => !activeIds.contains(json['id'].toString())).toList();

      return filteredData.map((json) => ActionModel.fromJson(json)).toList();
    } catch (e) {
      print("Erreur Fetch Actions: $e");
      return [];
    }
  }

  // --- 2. MES DÉFIS (Actions en cours avec progression) ---
  Future<List<ActionModel>> fetchMyChallenges(String userId) async {
    try {
      // Récupère les actions liées au compte de l'utilisateur
      final response = await supabaseClient
          .from('actions_en_cours')
          .select('progression, mode_de_vie, actions(*)')
          .eq('utilisateur_id', userId)
          .eq('est_actif', true);

      final data = response as List<dynamic>;

      return data.where((json) => json['actions'] != null).map((json) {
        final actionData = json['actions'];
        final Map<String, dynamic> actionJson = actionData is List ? Map<String, dynamic>.from(actionData.first) : Map<String, dynamic>.from(actionData);

        // Ajoute les infos de progression et de "mode de vie" dans l'objet action
        actionJson['progression'] = json['progression'] ?? 0;
        actionJson['mode_de_vie'] = json['mode_de_vie'] ?? false;

        return ActionModel.fromJson(actionJson);
      }).toList();
    } catch (e) {
      print("❌ Erreur chargement de Mes défis: $e");
      return [];
    }
  }

  // --- 3. REJOINDRE UN DÉFI ---
  Future<void> joinChallenge(String userId, String actionId, String frequence) async {
    // Vérifie si le défi n'est pas déjà dans la liste de l'utilisateur
    final existingChallenge = await supabaseClient.from('actions_en_cours').select().eq('utilisateur_id', userId).eq('action_id', actionId).eq('est_actif', true);
    if ((existingChallenge as List).isNotEmpty) throw Exception("ALREADY_JOINED");

    // Vérifie la limite autorisée pour ce type de fréquence (ex: max 5 défis quotidiens)
    String limitFreqKey = _mapToLimitFreq(frequence);
    final limitResponse = await supabaseClient.from('limite_actions_freq').select('nombre').eq('frequence', limitFreqKey).maybeSingle();
    int maxAllowed = limitResponse != null ? limitResponse['nombre'] as int : 5;

    // Compte combien de défis de cette fréquence sont déjà actifs
    final activeChallengesResponse = await supabaseClient.from('actions_en_cours').select('actions(frequence)').eq('utilisateur_id', userId).eq('est_actif', true);
    int currentCountForThisFreq = 0;
    for (var row in (activeChallengesResponse as List)) {
      final actionData = row['actions'];
      if (actionData != null) {
        final Map<String, dynamic> actionJson = actionData is List ? Map<String, dynamic>.from(actionData.first) : Map<String, dynamic>.from(actionData);
        if (_mapToLimitFreq(actionJson['frequence'] ?? '') == limitFreqKey) currentCountForThisFreq++;
      }
    }

    // Bloque si la limite est atteinte
    if (currentCountForThisFreq >= maxAllowed) throw Exception("LIMIT_REACHED");

    // Ajoute le nouveau défi en base de données
    await supabaseClient.from('actions_en_cours').insert({
      'utilisateur_id': userId,
      'action_id': actionId,
      'est_actif': true,
      'progression': 0,
      'mode_de_vie': false,
    });
  }

  // --- 4. VALIDER UNE ACTION (Augmente le score et la progression) ---
  Future<void> validateAction(String userId, String actionId, int xp, double co2) async {
    // Récupère et augmente la progression actuelle (+1)
    final currentChallenge = await supabaseClient.from('actions_en_cours').select('progression').eq('utilisateur_id', userId).eq('action_id', actionId).single();
    int prog = (currentChallenge['progression'] as num?)?.toInt() ?? 0;

    await supabaseClient.from('actions_en_cours').update({'progression': prog + 1}).eq('utilisateur_id', userId).eq('action_id', actionId);

    // Enregistre l'historique de l'action réussie
    await supabaseClient.from('realisation_actions').insert({
      'utilisateur_id': userId,
      'action_id': actionId,
      'xp_gagne': xp,
      'co2_economise': co2,
      'date_realisation': DateTime.now().toUtc().toIso8601String()
    });

    // Met à jour le total d'XP et de CO2 de l'utilisateur
    final userRes = await supabaseClient.from('utilisateur').select('impact_score_xp, co2_economise_total').eq('id', userId).single();
    int currentXp = (userRes['impact_score_xp'] as num?)?.toInt() ?? 0;
    double currentCo2 = (userRes['co2_economise_total'] as num?)?.toDouble() ?? 0.0;

    await supabaseClient.from('utilisateur').update({
      'impact_score_xp': currentXp + xp,
      'co2_economise_total': currentCo2 + co2
    }).eq('id', userId);
  }

  // --- 5. PASSER EN MODE DE VIE (Habitude acquise) ---
  Future<void> setLifestyle(String userId, String actionId, bool isLifestyle) async {
    await supabaseClient.from('actions_en_cours').update({'mode_de_vie': isLifestyle}).eq('utilisateur_id', userId).eq('action_id', actionId);
  }

  // --- 6. ARRÊTER UN DÉFI ---
  Future<void> removeChallenge(String userId, String actionId) async {
    await supabaseClient.from('actions_en_cours').delete().eq('utilisateur_id', userId).eq('action_id', actionId);
  }

  // Harmonise les noms de fréquence pour les calculs de limites
  String _mapToLimitFreq(String f) {
    String freq = f.toLowerCase().trim();
    if (freq.contains('jour') || freq.contains('quotidien')) return 'quotidienne';
    if (freq.contains('hebdo') || freq.contains('semaine')) return 'hebdomadaire';
    if (freq.contains('mensuel') || freq.contains('mois')) return 'mensuelle';
    if (freq.contains('unique') || freq.contains('bonus') || freq.contains('shot')) return 'bonus';
    return 'quotidienne';
  }
}