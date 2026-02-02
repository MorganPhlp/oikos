import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/domain/entities/company.dart';
import 'package:oikos/features/admin/domain/entities/user.dart';

abstract class CommunityRep {
  Future<void> updateCode(String newCode, String communityId);
  Future<void> createCommunity({
    required String name,
    required String code,
    required companyId,
    required String id,
  });
  Future<List<Community>> getCommunityData();
  Future<List<User>> getUserData();
  Future<List<Company>> getCompanyData();
  Future<void> deleteCommunity(String communityId);
  Future<bool> checkExistCode(String code);

}
