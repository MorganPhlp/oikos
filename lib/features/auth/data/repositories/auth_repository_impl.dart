import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabaseClient; // TODO: Remplacer par data source
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({
    required this.supabaseClient, // TODO: Remplacer par data source
    required this.remoteDataSource,
  });

  @override
  Future<String?> getUserId() async {
    final user = supabaseClient.auth.currentUser;
    return user?.id;
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        pseudo: pseudo,
        communityCode: communityCode,
      ),
    );
  }

  // Helper method to reduce code duplication
  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();

      return right(user);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
