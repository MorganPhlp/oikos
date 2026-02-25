import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/user_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class UserImpl extends UserRep {
  final SupabaseClient supabase;
  UserImpl(this.supabase);

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      final id = supabase.auth.currentUser?.id;
      if (id == null) return left(Failure('Utilisateur non authentifié'));
      await supabase
          .from('utilisateur')
          .update(user.toJson())
          .eq('id', id);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id) async {
    final response = await supabase
        .from('utilisateur')
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  @override
  Future<void> setObjetifsUtilisateur(double objectifRatio) async {
    final id = supabase.auth.currentUser?.id;
    if (id == null) throw Exception('Utilisateur non authentifié');
    await supabase
        .from('utilisateur')
        .update({'objectif': objectifRatio})
        .eq('id', id);
  }
}