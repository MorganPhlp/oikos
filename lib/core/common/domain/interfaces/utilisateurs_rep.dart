import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

abstract class UtilisateursRep {
  Future<Either<Failure, void>> updateUser(Utilisateurs user);
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id);
  Future<void> setObjetifsUtilisateur(double objectifRatio);
  Future<Either<Failure, List<Utilisateurs>>> getUsers(String companyId);
  Future<Either<Failure, Utilisateurs>> anonymizeUser(Utilisateurs user);
}
