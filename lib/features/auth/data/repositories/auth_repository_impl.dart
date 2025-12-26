import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    // TODO: Temporaire
    final user = supabaseClient.auth.currentUser;
    return user?.id;
  }

  @override
  Future<Either<Failure, String>> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        pseudo: pseudo,
        communityCode: communityCode,
      );

      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
