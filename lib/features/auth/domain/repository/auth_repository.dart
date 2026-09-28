import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';

import '../../../../core/error/failures.dart';

enum SessionChange { signedIn, signedOut, passwordRecovery }

abstract interface class AuthRepository {
  Stream<SessionChange> get sessionChanges;

  Future<String?> getUserId();

  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  });

  Future<Either<Failure, UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> currentUser();

  Future<Either<Failure, (String name, String? logoUrl)>> getCompanyByEmail({
    required String email,
  });

  Future<Either<Failure, String>> verifyCommunityCode({
    required String communityCode,
  });

  Future<Either<Failure, bool>> isPseudoUnique({required String pseudo});

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, UserEntity>> updateUser({
    String? pseudo,
    String? avatar,
    bool? isActive,
  });

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, void>> updateCredentials({
    String? email,
    String? password,
    String? currentPassword,
  });
}
