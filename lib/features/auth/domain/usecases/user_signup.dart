import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/common/entities/user.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class UserSignup implements UseCase<User, UserSignupParams>{
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassword(
        email: params.email,
        password: params.password,
        pseudo: params.pseudo,
        communityCode: params.communityCode,
    );
  }
}

// Classe pour donner plusieurs paramètres au UseCase
class UserSignupParams {
  final String email;
  final String password;
  final String pseudo;
  final String communityCode;

  UserSignupParams({
    required this.email,
    required this.password,
    required this.pseudo,
    required this.communityCode,
  });
}