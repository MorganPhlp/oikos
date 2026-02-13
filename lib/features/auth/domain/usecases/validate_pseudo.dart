import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

class ValidatePseudo implements UseCase<bool, String>{
  final AuthRepository authRepository;

  const ValidatePseudo(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(String pseudo) async {
    if(pseudo.trim().length < 3) {
      return left(Failure("Le pseudo doit contenir au moins 3 caractères."));
    }

    final isUniqueRes = await authRepository.isPseudoUnique(pseudo: pseudo);

    return isUniqueRes.fold(
      (failure) => left(failure),
      (isUnique) {
        if(!isUnique) {
          return left(Failure("Ce pseudo est déjà pris, désolé !"));
        }
        return right(true);
      },
    );
  }
}