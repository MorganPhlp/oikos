import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UtilisateursImpl extends UtilisateursRep {
  final SupabaseClient supabase;
  UtilisateursImpl(this.supabase);

  @override
  Future<Either<Failure, List<Utilisateurs>>> getUsers(String companyId) async {
    try {
      final response = await supabase.from('utilisateur').select().eq('entreprise_id', companyId);

      final users = response.map((json) => Utilisateurs.fromJson(json)).toList();
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
  Future<Either<Failure, void>> updateUser(Utilisateurs user) async {
    try {
      // Exclure 'id' du payload — on ne doit jamais tenter de modifier la PK
      final payload = user.toJson()..remove('id');
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
  Future<Either<Failure, Utilisateurs>> anonymizeUser(Utilisateurs user) async {
    try {
      Uuid uuid = Uuid();
      String anonymizedEmail = "anonymous@${uuid.v1()}.fr";
      String anonymizedPseudo = "anonyme-${uuid.v1()}";
      String anonymeCompanyId = await supabase
          .from('entreprise')
          .select('id')
          .eq('nom', 'Anonyme')
          .single()
          .then((res) => res['id']);
      String anoynymeCommunityCode = await supabase
          .from('communaute')
          .select('code')
          .eq('entreprise_id', anonymeCompanyId)
          .single()
          .then((res) => res['code']);

      await supabase.from('utilisateur').update(user.copyWith(
        email: anonymizedEmail,
        pseudo: anonymizedPseudo,
        codeCommunaute: anoynymeCommunityCode,
        entrepriseId: anonymeCompanyId,
        etatCompte: EtatCompte.anonymise,
      ).toJson(
      )).eq('id', user.id);

      return right(
        user.copyWith(
          email: anonymizedEmail,
          pseudo: anonymizedPseudo,
          codeCommunaute: anoynymeCommunityCode,
          entrepriseId: anonymeCompanyId,
          etatCompte: EtatCompte.anonymise,
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
