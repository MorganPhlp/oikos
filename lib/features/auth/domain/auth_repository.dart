import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';

abstract interface class AuthRepository {
  Future<String?> getUserId();

  Future<Either<Failure, String>> signUpWithEmailPassword({ //
    required String email,
    required String password,
  }); // TODO : Remplacer String par UserModel

  Future<Either<Failure, String>> signInWithEmailPassword({
    required String email,
    required String password,
  }); // TODO : Remplacer String par UserModel
}