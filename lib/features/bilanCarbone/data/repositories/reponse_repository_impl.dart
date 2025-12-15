import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReponseRepositoryImpl implements ReponseRepository {
  SupabaseClient supabaseClient;

  ReponseRepositoryImpl({required this.supabaseClient});

@override
  Future<void> saveReponse(ReponseUtilisateurEntity reponse) async {
    try {
      final data = reponse.toJson();

      await supabaseClient
          .from('reponse_utilisateur')
          .upsert(data, onConflict: 'bilan_id, question_id');
          
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de la réponse : $e');
    }
  }

  @override
  Future<List<ReponseUtilisateurEntity>> getReponses(int bilanId) async {
    try {
      final response = await supabaseClient
          .from('reponse_utilisateur')
          .select()
          .eq('bilan_id', bilanId);
      final data = response as List<dynamic>;
      return data
          .map((json) => ReponseUtilisateurEntity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des réponses : $e');
    }
  }

  @override
  /// Supprime toutes les réponses associées à un bilan spécifique
  Future<void> deleteReponsesForBilan(int bilanId) async {
    try {
      await supabaseClient
          .from('reponse_utilisateur')
          .delete()
          .eq('bilan_id', bilanId);
    } catch (e) {
      throw Exception('Erreur lors de la suppression des réponses : $e');
    }
  }

  @override
  Future<ReponseUtilisateurEntity?> getReponse(int bilanId, int questionId){
    try {
      return supabaseClient
          .from('reponse_utilisateur')
          .select()
          .eq('bilan_id', bilanId)
          .eq('question_id', questionId)
          .single()
          .then((json) => ReponseUtilisateurEntity.fromJson(json))
          .catchError((_) => null);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la réponse : $e');
    }
  }
}