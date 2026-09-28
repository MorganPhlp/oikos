import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

abstract class UtilisateursRep {
  Future<Either<Failure, void>> updateUser(UserEntity user);
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id);
  Future<void> setObjetifsUtilisateur(double objectifRatio);
  Future<Either<Failure, List<UserEntity>>> getUsers(String companyId);
  Future<Either<Failure, UserEntity>> anonymizeUser(UserEntity user);
}
