import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityImpl extends CommunityRep {
  final SupabaseClient supabase;

  CommunityImpl(this.supabase);

  @override
  Future<Either<Failure, void>> updateCode(
    String newCode,
    String oldCode,
  ) async {
    try {
      if (newCode.isNotEmpty) {
        await supabase
            .from('communaute')
            .update({"code": newCode.toUpperCase()})
            .eq("code", oldCode);
      }
      return right(null);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, List<Community>>> getCommunityData(
    String companyId,
  ) async {
    try {
      final response = await supabase.from('vue_communaute').select();

      final communities = response
          .map((json) => Community.fromJson(json))
          .toList();
      return right(communities);
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur lors de la récupération des communautés"));
    }
  }

  @override
  Future<Either<Failure, void>> createCommunity(Community community) async {
    try {
      // 1. On convertit en Map
      final communityMap = community.toJson();

      // 2. On crée une copie modifiable et on retire les champs calculés de la vue
      final dataToInsert = Map<String, dynamic>.from(communityMap)
        ..remove('bilan_moyen')
        ..remove('nombre_membres');

      // 3. On insère dans la table (et non la vue)
      await supabase.from('communaute').insert(dataToInsert);
      return right(null);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, bool>> checkExistCode(String code) async {
    try {
      final response = await supabase.from('communaute').select('code');
      bool codeExist = false;
      for (int i = 0; i < response.length; i++) {
        if (response[i]['code'] == code) codeExist = true;
      }
      return right(codeExist);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCommunity(String code) async {
    try {
      await supabase.from('communaute').delete().eq('code', code);
      return right(null);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, void>> updateLogo(
    String communityCode,
    String logoFileName,
  ) async {
    try {
      await supabase
          .from('communaute')
          .update({'logo_url': logoFileName})
          .eq('code', communityCode);
      return right(null);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }
}
