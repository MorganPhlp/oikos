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
    // Validation Regex
    final emailError = AuthValidators.validateEmail(params.email);
    if(emailError != null){
      return left(Failure(emailError));
    }

    final passwordError = AuthValidators.passwordErrorText(params.password);
    if(passwordError != null){
      return left(Failure(passwordError));
    }

    // Vérification de l'existence de l'email
    final emailCheck = await authRepository.verifyEmailUniqueness(email: params.email);
    
    return emailCheck.fold(
        (failure) => left(failure),
        (exists) async {
          if(exists){
            return left(Failure("L'adresse email existe déjà"));
          }

          final companyCheck = await authRepository.getCompanyByEmail(email: params.email);

          return companyCheck.fold(
              (failure) => left(Failure("L'entreprise n'existe pas")),
              (companyInfo) => right(true)
          );
        }
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