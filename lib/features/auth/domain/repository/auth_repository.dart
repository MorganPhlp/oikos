import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/entities/user.dart';

import '../../../../core/error/failures.dart';

abstract interface class AuthRepository {
  Future<String?> getUserId();

  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  });

  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, (String name, String? logoUrl)>> getCompanyByEmail({
    required String email,
  });

  Future<Either<Failure, String>> verifyCommunityCode({
    required String communityCode,
  });
}
