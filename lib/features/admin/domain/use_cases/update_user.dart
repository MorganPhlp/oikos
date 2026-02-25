import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';

class UpdateUser {
  final UtilisateursRep repository;

  UpdateUser(this.repository);

  Future<Either<Failure, void>> call(Utilisateurs user) async {
    if (user.pseudo.length < 3) {
      return left(Failure("Le pseudo est trop court"));
    }
    return await repository.updateUser(user);
  }
}
