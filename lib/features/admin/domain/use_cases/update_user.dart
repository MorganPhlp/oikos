import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/features/admin/domain/repositories/user_rep.dart';

class UpdateUser {
  final UserRep repository;

  UpdateUser(this.repository);

  Future<Either<Failure, void>> call(User user) async {
    if (user.pseudo.length < 3) {
      return left(Failure("Le pseudo est trop court"));
    }
    return await repository.updateUser(user);
  }
}
