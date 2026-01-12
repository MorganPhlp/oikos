import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/utils/auth_validators.dart';

class ValidateEmailPassword implements UseCase<bool, ValidateEmailPasswordParams>{
  final AuthRepository authRepository;

  const ValidateEmailPassword(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(ValidateEmailPasswordParams params) async {
    if(!AuthValidators.isValidEmail(params.email)){
      return left(Failure("Format d'email invalide"));
    }

    final passwordError = AuthValidators.passwordErrorText(params.password);
    if(passwordError != null){
      return left(Failure(passwordError));
    }

    final companyCheck = await authRepository.getCompanyByEmail(email: params.email);

    return companyCheck.fold(
        (failure) => left(Failure("Votre email ne correspond à aucune entreprise inscrite.")),
        (_) => right(true),
    );
  }
}

class ValidateEmailPasswordParams {
  final String email;
  final String password;

  ValidateEmailPasswordParams({
    required this.email,
    required this.password,
  });
}