import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/common/domain/repositories/categorie_empreinte_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategorieEmpreinteRepositoryImpl implements CategorieEmpreinteRepository {
  final SupabaseClient _supabase;

  CategorieEmpreinteRepositoryImpl({required SupabaseClient supabaseClient}) 
      : _supabase = supabaseClient;

  @override
  Future<List<CategorieEmpreinteEntity>> getCategories() async {
    try {
      final List<Map<String, dynamic>> data = await _supabase
          .from('categorie_empreinte')
          .select()
          .order('nom', ascending: true);

      // Mapping fluide grâce à Freezed
      return data
          .map((json) => CategorieEmpreinteEntity.fromJson(json))
          .toList();
          
    } on PostgrestException catch (e) {
      // Capture spécifique aux erreurs de base de données
      throw Exception('Erreur Supabase: ${e.message}');
    } catch (e) {
      // Capture générique (ex: problème réseau)
      throw Exception('Une erreur inattendue est survenue: $e');
    }
  }

  @override
  Future<void> setSelectedCategories(List<CategorieEmpreinteEntity> categories) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non authentifié');

      // Suppression de toutes les préférences actuelles de l'utilisateur
      await _supabase
          .from('utilisateur_categorie_preference')
          .delete()
          .eq('utilisateur_id', user.id);

      // Si la liste n'est pas vide, on insère les nouvelles préférences
      if (categories.isNotEmpty){
        final dataToInsert = categories.map((cat) => {
          'utilisateur_id': user.id,
          'categorie_nom': cat.nom,
        }).toList();

        await _supabase
            .from('utilisateur_categorie_preference')
            .insert(dataToInsert);
      }
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde des centres d\'intérêts: $e');
    }
  }

  @override
  Future<List<CategorieEmpreinteEntity>> getSelectedCategories() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non authentifié');

      final List<Map<String, dynamic>> data = await _supabase
          .from('utilisateur_categorie_preference')
          .select('categorie_nom(*)')
          .eq('utilisateur_id', user.id);

      return data
          .map((json) => CategorieEmpreinteEntity.fromJson(json['categorie_nom']))
          .toList();

    } catch (e) {
      throw Exception('Erreur lors de la récupération des catégories sélectionnées: $e');
    }
  }
}