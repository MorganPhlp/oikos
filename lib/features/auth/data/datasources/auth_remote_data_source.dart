import 'package:oikos/core/secrets/app_secrets.dart';
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

  Future<void> resetPassword({required String email});

  Future<UserModel> updateUserData({
    String? pseudo,
    String? avatar,
    bool? isActive,
  });

  Future<void> anonymizeAccount();

  Future<void> updateCredentials({
    String? email,
    String? password,
    String? currentPassword,
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
        data: {'pseudo': pseudo, 'code_communaute': communityCode},
      );
      if (response.user == null) {
        throw ServerException('User is null');
      }

      if (response.session == null) {
        throw ServerException(
          "Confirme ton adresse email avant de te connecter.",
        );
      }

      // Récupérer les données complètes de l'utilisateur depuis la table utilisateur
      final userData = await supabaseClient
          .from('utilisateur')
          .select()
          .eq('id', response.user!.id)
          .single();

      // Merger les données de auth.users et utilisateur
      final mergedData = userData;
      return UserModel.fromJson(mergedData);
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
      // on récupère les donnees supplémentaires de l'utilisateur
      final userData = await supabaseClient
          .from('utilisateur')
          .select()
          .eq('id', response.user!.id)
          .single();

      // On bloque la connexion si le compte est anonyme
      if (userData['etat_compte'] == 'ANONYMISE' ||
          userData['est_compte_valide'] == false) {
        await supabaseClient.auth
            .signOut(); // On s'assure de se déconnecter pour éviter les sessions fantômes
        throw ServerException('Ce compte a été anonymisé ou supprimé.');
      }

      // on merge les deux maps
      final mergedData = userData;
      return UserModel.fromJson(mergedData);
    } catch (e) {
      await supabaseClient.auth
          .signOut(); // On s'assure de se déconnecter en cas d'erreur pour éviter les sessions fantômes
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
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
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: AppSecrets.authRedirectUrl,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserData({
    String? pseudo,
    String? avatar,
    bool? isActive,
  }) async {
    try {
      final user = currentUserSession?.user;
      if (user == null) {
        throw ServerException('User not logged in');
      }

      final updates = <String, dynamic>{};
      if (pseudo != null) updates['pseudo'] = pseudo;
      if (avatar != null) updates['avatar_url'] = avatar;
      if (isActive != null) updates['est_actif'] = isActive;

      if (updates.isEmpty) {
        return getCurrentUserData().then(
          (data) => data!,
        ); // Si aucune mise à jour, on retourne les données actuelles
      }

      final userData = await supabaseClient
          .from('utilisateur')
          .update(updates)
          .eq('id', user.id)
          .select()
          .single();

      // Fusion des données
      final mergedData = userData;

      return UserModel.fromJson(mergedData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> anonymizeAccount() async {
    try {
      final user = currentUserSession?.user;
      if (user == null) {
        throw ServerException('User not logged in');
      }
      await supabaseClient.rpc(
        'anonymize_user',
        params: {'target_user_id': user.id},
      );
      await supabaseClient.auth
          .signOut(); // Déconnexion de l'utilisateur après anonymisation
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateCredentials({
    String? email,
    String? password,
    String? currentPassword,
  }) async {
    try {
      if (currentPassword != null) {
        final currentEmail = supabaseClient.auth.currentUser?.email;
        if (currentEmail == null) throw ServerException('Session expirée.');
        await supabaseClient.auth.signInWithPassword(
          email: currentEmail,
          password: currentPassword,
        );
      }

      final user = currentUserSession?.user;
      if (user == null) {
        throw ServerException('User not logged in');
      }

      if (email == null && password == null) {
        throw ServerException('No credentials provided for update');
      }

      if (email != null) {
        await supabaseClient.auth.updateUser(UserAttributes(email: email));

        // The database syncs email only after Auth confirms the change.
      }

      if (password != null) {
        await supabaseClient.auth.updateUser(
          UserAttributes(password: password),
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
