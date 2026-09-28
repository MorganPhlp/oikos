import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';
import 'package:oikos/core/error/failures.dart';

class AnonymizeUser {
  final UtilisateursRep userRepository;

  AnonymizeUser(this.userRepository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await userRepository.anonymizeUser(user);
  }
}
