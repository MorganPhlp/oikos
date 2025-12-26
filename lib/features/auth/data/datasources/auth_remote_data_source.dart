import 'package:oikos/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  });

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'pseudo': pseudo,
          'community_code': communityCode,
        }
      );
      if(response.user == null) {
        throw ServerException('User is null');
      }
      return response.user!.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }
}
