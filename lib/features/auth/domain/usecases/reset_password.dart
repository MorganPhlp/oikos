import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/error/failures.dart';

class ResetPassword implements UseCase<void, String>{
  final AuthRepository authRepository;

  ResetPassword(this.authRepository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await authRepository.resetPassword(email: email);
  }
}