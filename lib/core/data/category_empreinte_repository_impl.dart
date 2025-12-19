import 'package:oikos/core/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/domain/repositories/categorie_empreinte_repository.dart';
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

      // 1. Préparer les données pour une insertion groupée (Bulk insert)
      // C'est beaucoup plus performant qu'une boucle !
      final dataToUpsert = categories.map((cat) => {
        'utilisateur_id': user.id,
        'categorie_nom': cat.nom,
      }).toList();

      // 2. Exécuter l'upsert en une seule fois
      // Supabase gère très bien les listes de Maps pour l'upsert.
      await _supabase
          .from('utilisateur_categorie_preference')
          .upsert(dataToUpsert, onConflict: 'utilisateur_id, categorie_nom'); 
          // Note: l'onConflict dépend de tes contraintes en base de données

    } catch (e) {
      // Dans les versions récentes de supabase_flutter, les erreurs lancent des PostgrestException
      throw Exception('Erreur lors de la sélection des catégories: $e');
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