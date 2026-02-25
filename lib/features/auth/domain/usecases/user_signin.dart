import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/common/domain/usecase/usecase.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignin implements UseCase<Utilisateurs, UserSigninParams> {
  final AuthRepository repository;

  const UserSignin({required this.repository});

  @override
  Future<Either<Failure, Utilisateurs>> call(UserSigninParams params) async {
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
