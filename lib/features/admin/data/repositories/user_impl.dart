import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/features/admin/domain/repositories/user_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart'as supa;

class UserImpl implements UserRep {
  final supa.SupabaseClient supabase;

  UserImpl(this.supabase);

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      await supabase
          .from('utilisateur')
          .update(user.toJson())
          .eq('id', user.id);
      return right(null);
    } on supa.PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }
}
