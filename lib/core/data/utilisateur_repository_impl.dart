import 'package:oikos/core/domain/repositories/utilisateur_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UtilisateurRepositoryImpl implements UtilisateurRepository {
  final SupabaseClient _supabase;
  UtilisateurRepositoryImpl({required SupabaseClient supabaseClient}) 
      : _supabase = supabaseClient; 

  @override
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id) async {
    // Implémentation de la méthode pour obtenir un utilisateur par son ID
    final response = await _supabase
        .from('utilisateur')
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  @override
  Future<void> setObjetifsUtilisateur( double objectifRatio) async {
    // Implémentation de la méthode pour définir les objectifs d'un utilisateur
    final id = _supabase.auth.currentUser?.id;
    if (id == null) throw Exception('Utilisateur non authentifié');
    await _supabase
        .from('utilisateur')
        .update({'objectif': objectifRatio})
        .eq('id', id);
  }
}