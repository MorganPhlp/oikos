import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/repositories/community_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;


class CommunityImpl extends CommunityRep {
  final SupabaseClient supabase;

  CommunityImpl(this.supabase);

  @override
  Future<Either<Failure, void>> updateCode(
    String newCode,
    String oldCode,
  ) async {
    try {
      // if (newCode.isNotEmpty) {
      //   await supabase
      //       .from('communaute')
      //       .update({"code": newCode.toUpperCase()})
      //       .eq("code", oldCode);
      // }
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
      // final response = await supabase.from('vue_communautes').select();

      final mokResponse = [
        {
          "code": "VIVDEV",
          "nom": "VIVERIS DEV TEAM",
          "entreprise_id": "2efcc515-54c1-4beb-a45a-90cc251d5792",
          "description": "Communauté des développeurs de Viveris.",
          "nombre_membres": 3,
          "bilan_moyen": 5.8,
        },
        {
          "code": "VIVRH",
          "nom": "VIVERIS RH & ADMIN",
          "entreprise_id": "2efcc515-54c1-4beb-a45a-90cc251d5792",
          "description": "Équipe administrative Viveris.",
          "nombre_membres": 2,
          "bilan_moyen": 7.0,
        },
        {
          "code": "ECOMKT",
          "nom": "EcoCorp Marketing".toUpperCase(),
          "entreprise_id": "2efcc515-54c1-4beb-a45a-90cc251d5792",
          "description": "Marketing vert.",
          "nombre_membres": 5,
          "bilan_moyen": 9.9,
        },
        {
          "code": "ECOPROD",
          "nom": "EcoCorp Production".toUpperCase(),
          "entreprise_id": "2efcc515-54c1-4beb-a45a-90cc251d5792",
          "description": "L'usine responsable.",
          "nombre_membres": 0,
          "bilan_moyen": 0.0,
        },
      ];
      final communities = mokResponse
          .map((json) => Community.fromJson(json))
          .toList();
      return right(communities);
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur lors de la récupération des communautés"));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUserData(String companyId) async {
    try {
      // final response = await supabase
      //     .from('utilisateur')
      //     .select('id,email,pseudo,code_communaute');
      final mokResponse = [
        {
          "id": "u1",
          "email": "alice@viveris.fr",
          "pseudo": "Alice_V",
          "code_communaute": "VIVDEV",
        },
        {
          "id": "u2",
          "email": "bob@viveris.fr",
          "pseudo": "Bob_V",
          "code_communaute": "VIVDEV",
        },
        {
          "id": "u3",
          "email": "charlie@viveris.fr",
          "pseudo": "Charlie_V",
          "code_communaute": "VIVDEV",
        },

        {
          "id": "u4",
          "email": "dora@viveris.fr",
          "pseudo": "Dora_RH",
          "code_communaute": "VIVRH",
        },
        {
          "id": "u5",
          "email": "eric@viveris.fr",
          "pseudo": "Eric_RH",
          "code_communaute": "VIVRH",
        },

        {
          "id": "u6",
          "email": "frank@ecocorp.com",
          "pseudo": "Franky",
          "code_communaute": "ECOMKT",
        },
        {
          "id": "u7",
          "email": "grace@ecocorp.com",
          "pseudo": "Grace_E",
          "code_communaute": "ECOMKT",
        },
        {
          "id": "u8",
          "email": "heidi@ecocorp.com",
          "pseudo": "Heidi_P",
          "code_communaute": "ECOMKT",
        },

        {
          "id": "u9",
          "email": "ivan@ecocorp.com",
          "pseudo": "Ivan_M",
          "code_communaute": "ECOMKT",
        },
        {
          "id": "u10",
          "email": "judy@ecocorp.com",
          "pseudo": "Judy_M",
          "code_communaute": "ECOMKT",
        },
      ];
      final users = mokResponse.map((json) => User.fromJson(json)).toList();

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
  Future<Either<Failure, List<Company>>> getCompanyData(
    String companyId,
  ) async {
    try {
      // final response = await supabase.from('entreprise').select();

      final mokResponse = [
        {
          "id": "comp-111",
          "nom": "Viveris".toUpperCase(),
          "logo_url": "https://logo.com/viveris.png",
          "domaine_email": "viveris.fr",
          "description": "Expertise en conseil et ingénierie informatique.",
        },
        {
          "id": "comp-222",
          "nom": "EcoCorp".toUpperCase(),
          "logo_url": null,
          "domaine_email": "ecocorp.com",
          "description": "Leader de solutions durables.",
        },
      ];

      final companies = mokResponse
          .map((json) => Company.fromJson(json))
          .toList();
      return right(companies);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, void>> createCommunity(Community community) async {
    try {
      await supabase.from('communaute').insert({
        "code": community.code,
        "nom": community.name,
        "entreprise_id": community.companyId,
        "description": community.description,
        "logo_url": community.logoUrl,
        "couleurhex": "#FFFFFF", 
      });
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
      // final response = await supabase.from('communaute').select('code');
      // bool codeExist = false;
      // for (int i = 0; i < response.length; i++) {
      //   if (response[i]['code'] == code) codeExist = true;
      // }
      // return right(codeExist);
      return right(false);
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
      // await supabase.from('communaute').delete().eq('code', code);
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
      // await supabase
      //     .from('communaute')
      //     .update({'logo_url': logoFileName})
      //     .eq('code', communityCode);
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
