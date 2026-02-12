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

      if (response == null) {
        return {};
      }

      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du streak: $e');
    }
  }

  Future<String> getEntrepriseName(String entrepriseId) async {
    try {
      final response = await supabaseClient .from('entreprise').select('nom').eq('id', entrepriseId)
                                            .maybeSingle();
      if (response == null) {
         throw Exception('Entreprise non trouvée'); 
         } 
      return (response['nom'] as String); 
      } 
    catch (e) {
       throw Exception('Erreur lors de la récupération du nom de l\'entreprise: $e');
    }
  }

  // Méthode pour récupérer les infos de la saison en cours
  Stream<Map<String, dynamic>> getSaisonStream(String entrepriseId) {
    return supabaseClient
        .from('saison')
        .stream(primaryKey: ['id'])
        .eq('entreprise_id', entrepriseId)
        .order('start_date', ascending: false)
        .limit(1)
        .map((list) => list.isEmpty ? {} : list.first);
  }
}
