import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/common/domain/entities/user.dart';
import '../repository/auth_repository.dart';

class CurrentUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  CurrentUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.currentUser();
  }
}
