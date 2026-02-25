import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/models.dart';

abstract class CommunityRep {
  Future<Either<Failure, void>> updateCode(String newCode, String oldCode);
  Future<Either<Failure, void>> createCommunity(Community community);
  Future<Either<Failure, List<Community>>> getCommunityData(String companyId);
  Future<Either<Failure, List<User>>> getUserData(String companyId);
  Future<Either<Failure, List<Company>>> getCompanyData(String companyId);
  Future<Either<Failure, void>> deleteCommunity(String code);
  Future<Either<Failure, bool>> checkExistCode(String code);
  Future<Either<Failure, void>> updateLogo(String communityCode, String logoFileName);
}
