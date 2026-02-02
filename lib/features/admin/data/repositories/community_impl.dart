import 'package:oikos/core/logger.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/features/admin/data/models/company_model.dart';
import 'package:oikos/features/admin/data/models/user_model.dart';
import 'package:oikos/features/admin/domain/entities/user.dart' as u;
import 'package:oikos/features/admin/data/models/community_model.dart';
import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/domain/entities/company.dart';

class CommunityImpl extends CommunityRep {
  final SupabaseClient supabase;

  CommunityImpl(this.supabase);

  @override
  Future<void> updateCode(String newCode, String communityId) async {
    try {
      if (newCode.isNotEmpty) {
        await supabase
            .from('communities')
            .update({"code": newCode.toUpperCase()})
            .eq("id", communityId);
      }
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);

      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<List<Community>> getCommunityData() async {
    try {
      // On interroge la vue SQL créée précédemment
      final response = await supabase.from('community_card').select();

      // On mappe la liste JSON en liste de CommunityModel (qui sont des Community)
      return (response as List)
          .map((json) => CommunityModel.fromJson(json))
          .toList();
    } catch (e) {
      logger.e("Erreur Repository",error:e);
      
      throw Exception("Erreur lors de la récupération des communautés : $e");
    }
  }

  @override
  Future<List<u.User>> getUserData() async {
    try {
      final response = await supabase
          .from('users')
          .select('id,email,pseudo,community_id');

      return (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);

      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<List<Company>> getCompanyData() async {
    try {
      final response = await supabase.from('companies').select();
      return (response as List)
          .map((json) => CompanyModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);

      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<void> createCommunity({
    required String name,
    required String code,
    required companyId,
    required String id,
  }) async {
    try {
      await supabase.from('communities').insert({
        "id": id,
        "name": name,
        "code": code.toUpperCase(),
        "company_id": companyId,
      });
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<bool> checkExistCode(String code) async {
    try {
      final response = await supabase.from('communities').select('code');

      bool codeExist = false;

      for (int i = 0; i < response.length; i++) {
        if (response[i]['code'] == code) codeExist = true;
      }
      return codeExist;
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<void> deleteCommunity(String communityId) async {
    try {
      await supabase.from('communities').delete().eq('id', communityId);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("une Erreur inattendu est survenue");
    }
  }
}
