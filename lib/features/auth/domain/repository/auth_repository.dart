import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import '../../../../core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, void>> updatePassword(String newPassword);
  Future<String?> getUserId();

  Future<Either<Failure, Utilisateurs>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  });

  Future<Either<Failure, Utilisateurs>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Utilisateurs>> currentUser();

  Future<Either<Failure, (String name, String? logoUrl)>> getCompanyByEmail({
    required String email,
  });

  Future<Either<Failure, String>> verifyCommunityCode({
    required String communityCode,
  });

  Future<Either<Failure, bool>> isPseudoUnique({required String pseudo});

  Future<Either<Failure, void>> signOut();
}
