import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  SupabaseClient get client;

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String pseudo,
    required String communityCode,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<bool> doesEmailExist(String email);

  Future<void> resetPassword({
    required String email
  });

  Future<UserModel> updateUserData({
    String? pseudo,
    String? avatar,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  // Pour utilisation dans le repository
  @override
  SupabaseClient get client => supabaseClient;

  @override
  Future<UserModel> signUpWithEmailAndPassword({
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
      //on ajoute les donnees supplementaires de l'utilisateur dans la table utilisateur
      await supabaseClient.from('utilisateur').update({
        'code_communaute': communityCode,
        'avatar_url': 'assets/avatars/avatar_1.png', // Avatar par défaut
      }).eq("id" , response.user!.id);
      
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
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
          .eq('id', response.user!.id).single();
      // on merge les deux maps
      final mergedData = {
        ...userData,
        ...response.user!.toJson(),
      };
      return UserModel.fromJson(mergedData);
    } catch (e) {
      await supabaseClient.auth.signOut(); // On s'assure de se déconnecter en cas d'erreur pour éviter les sessions fantômes
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if(currentUserSession == null) {
        return null;
      }
      final userData = await supabaseClient
          .from('utilisateur')
          .select()
          .eq('id', currentUserSession!.user.id);
      return UserModel.fromJson(userData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> doesEmailExist(String email) async {
    try {
      final response = await supabaseClient
          .from('utilisateur')
          .select()
          .ilike('email', email)
          .maybeSingle(); // Null si pas trouvé

      return response != null; // True si l'utilisateur existe, false sinon
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email
  }) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://oikos-reset.vercel.app/reset-password'
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserData({
    String? pseudo,
    String? avatar,
  }) async {
    try {
      final user = currentUserSession?.user;
      if (user == null) {
        throw ServerException('User not logged in');
      }

      final updates = <String, dynamic>{};
      if (pseudo != null) updates['pseudo'] = pseudo;
      if (avatar != null) updates['avatar_url'] = avatar;

      if(updates.isEmpty) {
        return getCurrentUserData().then((data) => data!); // Si aucune mise à jour, on retourne les données actuelles
      }

      final userData = await supabaseClient
          .from('utilisateur')
          .update(updates)
          .eq('id', user.id)
          .select()
          .single();

      // Fusion des données
      final mergedData = {
        ...userData,
        ...user.toJson(),
      };

      return UserModel.fromJson(mergedData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
