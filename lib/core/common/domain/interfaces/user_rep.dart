import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

abstract class UserRep {
  Future<Either<Failure, void>> updateUser(User user);
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id);
  Future<void> setObjetifsUtilisateur(double objectifRatio);
}
