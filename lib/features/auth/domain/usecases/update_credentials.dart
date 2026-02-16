import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';

class UpdateCredentials implements UseCase<void, UpdateCredentialsParams> {
  final AuthRepository authRepository;

  UpdateCredentials(this.authRepository);

  @override
  Future<Either<Failure, void>> call(UpdateCredentialsParams params) async {
    return await authRepository.updateCredentials(
      email: params.email,
      password: params.password,
    );
  }
}

class UpdateCredentialsParams {
  final String? email;
  final String? password;

  UpdateCredentialsParams({this.email, this.password});
}