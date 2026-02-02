import 'package:oikos/features/admin/data/models/user_model.dart';
import 'package:oikos/features/admin/domain/entities/user.dart' as u;
import 'package:oikos/features/admin/domain/interfaces/user_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/logger.dart';

class UserImpl implements UserRep {
  final SupabaseClient supabase;

  UserImpl(this.supabase);

  @override
  Future<void> updateUser(u.User user) async {
    try {
      // 1. On transforme l'entité en modèle pour accéder au .toJson()
      final model = UserModel(
        id: user.id,
        pseudo: user.pseudo,
        email: user.email,
        communityId: user.communityId,
        companyId: user.companyId,
        avatarUrl: user.avatarUrl,
      );

      // 2. On exécute l'update sur la table 'profiles' (ou 'users')
      // .eq('id', user.id) est CRUCIAL pour ne pas mettre à jour toute la table !
      await supabase.from('users').update(model.toJson()).eq('id', user.id);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);

      throw Exception("une Erreur inattendu est survenue");
    }
  }
}
