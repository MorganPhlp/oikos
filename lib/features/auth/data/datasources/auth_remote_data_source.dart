import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sup;

abstract interface class AuthRemoteDataSource {
  sup.Session? get currentUserSession;
  sup.SupabaseClient get client;

  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  });

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> getCurrentUserData();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final sup.SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  sup.Session? get currentUserSession => supabaseClient.auth.currentSession;

  // Pour utilisation dans le repository
  @override
  sup.SupabaseClient get client => supabaseClient;

  @override
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'pseudo': pseudo, 'community_code': communityCode},
      );
      if (response.user == null) {
        throw ServerException('User is null');
      }
      // on ajoute les donnees supplementaires de l'utilisateur dans la table utilisateur
      await supabaseClient
          .from('utilisateur')
          .update({'code_communaute': communityCode})
          .eq("id", response.user!.id);

      final userData = await supabaseClient
          .from('utilisateur')
          .select()
          .eq('id', response.user!.id)
          .single();

      return User.fromJson(userData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException('User is null');
      }
      // on recupere les donnees supplementaires de l'utilisateur
      final userData = await supabaseClient
          .from('utilisateur')
          .select()
          .eq('id', response.user!.id)
          .single();

      return User.fromJson(userData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
        return null;
      }
      final userData = await supabaseClient
          .from('utilisateur')
          .select()
          .eq('id', currentUserSession!.user.id);
      return User.fromJson(userData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
