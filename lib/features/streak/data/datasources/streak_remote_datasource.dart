import 'package:supabase_flutter/supabase_flutter.dart';

class StreakRemoteDatasource {
  SupabaseClient supabaseClient;

  StreakRemoteDatasource({required this.supabaseClient});

  // Méthode pour récupérer un stream du streak d'un utilisateur
  Stream<Map<String, dynamic>> getRawStreakStream(String userId) {
    return supabaseClient
        .from('utilisateur_streak')
        .stream(primaryKey: ['utilisateur_id'])
        .eq('utilisateur_id', userId)
        .map((list) => list.isEmpty ? {} : list.first);
  }

  // Méthode pour récupérer le streak actuel  et a jour d'un utilisateur
  Future<Map<String, dynamic>> getRawStreak(String userId) async {
    try {
      final response = await supabaseClient
          .from('vue_utilisateur_streak_live')
          .select()
          .eq('utilisateur_id', userId)
          .maybeSingle();

      if (response == null || response.isEmpty) {
        return await initStreak(userId);
      }

      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du streak: $e');
    }
  }

  Future<String> getEntrepriseName(String entrepriseId) async {
    try {
      final response = await supabaseClient
          .from('entreprise')
          .select('nom')
          .eq('id', entrepriseId)
          .maybeSingle();
      if (response == null) {
        throw Exception('Entreprise non trouvée');
      }
      return (response['nom'] as String);
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération du nom de l\'entreprise: $e',
      );
    }
  }

  // Méthode pour récupérer un stream de la saison en cours d'une entreprise
  Stream<Map<String, dynamic>> getSaisonStream(String entrepriseId) {
    return supabaseClient
        .from('saison')
        .stream(primaryKey: ['id'])
        .eq('entreprise_id', entrepriseId)
        .order('start_date', ascending: false)
        .limit(1)
        .map((list) => list.isEmpty ? {} : list.first);
  }

  Future<int> getNombreActionsQuotidiennesValidesDepuis(
    String userId,
    DateTime date,
  ) async {
    try {
      final response = await supabaseClient
          .from('realisation_actions')
          .select('*, actions!inner(frequence)')
          .eq('utilisateur_id', userId)
          .eq('actions.frequence', 'journalier')
          .gte('date_realisation', date.toIso8601String())
          .count(CountOption.exact);

      final int count = response.count;

      return count;
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération du nombre d\'actions quotidiennes valides: $e',
      );
    }
  }

  Future<bool> hasCompletedActionCommunautaire(String userId) async {
    // TODO: implémenter la logique réelle pour vérifier si l'utilisateur a complété une action communautaire
    return true;
  }

  Future<List<Map<String, dynamic>>> getStreakSteps() async {
    try {
      final response = await supabaseClient
          .from('streak_steps')
          .select()
          .order('from_streak_phase', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des étapes de streak: $e',
      );
    }
  }

  Future<Map<String, dynamic>> initStreak(String userId) async {
    await supabaseClient.from('utilisateur_streak').upsert({
      'utilisateur_id': userId,
      'current_streak': 0,
      'last_updated': DateTime.now().toUtc().toIso8601String(),
    });

    // On force un select sur la vue
    final response = await supabaseClient
        .from('vue_utilisateur_streak_live')
        .select()
        .eq('utilisateur_id', userId)
        .maybeSingle();

    return response ?? {};
  }

  Future<DateTime?> getSaisonDebut(String userId) async {
    final response = await supabaseClient
        .from('vue_utilisateur_streak_live')
        .select('saison_debut')
        .eq('utilisateur_id', userId)
        .maybeSingle();

    if (response == null || response['saison_debut'] == null) {
      return null;
    }

    return DateTime.parse(response['saison_debut'] as String);
  }
}
