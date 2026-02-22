import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';
import 'package:oikos/features/auth/data/models/user_model.dart';
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
  Future<void> setObjetifsUtilisateur(double objectifRatio) async {
    // Implémentation de la méthode pour définir les objectifs d'un utilisateur
    final id = _supabase.auth.currentUser?.id;
    if (id == null) throw Exception('Utilisateur non authentifié');
    await _supabase
        .from('utilisateur')
        .update({'objectif': objectifRatio})
        .eq('id', id);
  }

  @override
  Stream<UserEntity> watchUser(String id) {
    return _supabase
        .from('utilisateur')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map<UserEntity>((data) {
          if (data.isEmpty) {
            throw Exception("Utilisateur non trouvé");
          }

          final userMap = data.first;

          return UserModel.fromJson(userMap) as UserEntity;
        });
  }
}
