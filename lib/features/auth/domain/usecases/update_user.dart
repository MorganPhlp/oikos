import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';

class UpdateUser implements UseCase<User, UpdateUserParams> {
  final AuthRepository authRepository;

  UpdateUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    return await authRepository.updateUser(
      pseudo: params.pseudo,
      avatar: params.avatar,
      isActive: params.isActive,
    );
  }
}

class UpdateUserParams {
  final String? pseudo;
  final String? avatar;
  final bool? isActive;

  UpdateUserParams({this.pseudo, this.avatar, this.isActive});
}