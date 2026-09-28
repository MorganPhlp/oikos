import 'package:oikos/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UtilisateursImpl extends UtilisateursRep {
  final SupabaseClient supabase;
  UtilisateursImpl(this.supabase);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers(String companyId) async {
    try {
      final response = await supabase
          .from('utilisateur')
          .select()
          .eq('entreprise_id', companyId);

      final users = response.map((json) => UserModel.fromJson(json)).toList();
      return right(users);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserEntity user) async {
    try {
      // Exclure 'id' du payload — on ne doit jamais tenter de modifier la PK
      final payload = {
        'pseudo': user.pseudo,
        'avatar_url': user.avatar,
        'code_communaute': user.communityCode,
      };
      await supabase.from('utilisateur').update(payload).eq('id', user.id);
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

  @override
  Future<Either<Failure, UserEntity>> anonymizeUser(UserEntity user) async {
    try {
      await supabase.rpc('anonymize_user', params: {'target_user_id': user.id});

      return right(
        user.copyWith(
          email: '',
          pseudo: 'Anonyme',
          etatCompte: EtatCompte.anonymise,
          estCompteValide: false,
        ),
      );
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }
}
