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
}