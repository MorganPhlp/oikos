import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/core/common/entities/user.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignin implements UseCase<User, UserSigninParams> {
  final AuthRepository repository;

  const UserSignin({required this.repository});

  @override
  Future<Either<Failure, User>> call(UserSigninParams params) async {
    return await repository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSigninParams {
  final String email;
  final String password;

  UserSigninParams({required this.email, required this.password});
}
