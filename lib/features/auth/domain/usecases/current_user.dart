import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/common/domain/usecase/usecase.dart';
import '../../../../core/common/domain/entities/utilisateurs.dart';
import '../repository/auth_repository.dart';

class CurrentUser implements UseCase<Utilisateurs, NoParams> {
  final AuthRepository repository;

  CurrentUser(this.repository);

  @override
  Future<Either<Failure, Utilisateurs>> call(NoParams params) async {
    return await repository.currentUser();
  }
}
