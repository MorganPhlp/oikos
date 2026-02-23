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

  Future<void> resetPassword({required String email});

  Future<UserModel> updateUserData({
    String? pseudo,
    String? avatar,
    bool? isActive,
  });

  Future<void> anonymizeAccount();

  Future<void> updateCredentials({String? email, String? password});
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
      final mergedData = {...userData, ...response.user!.toJson()};
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
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://oikos-reset.vercel.app/reset-password',
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
      final mergedData = {...userData, ...user.toJson()};

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
      final domain =
          user.email?.split('@').last ??
          'example.com'; // Récupère le domaine de l'email ou utilise un domaine générique

      // Anonymisation des données de l'utilisateur
      await supabaseClient
          .from('utilisateur')
          .update({
            'pseudo':
                'Anonyme-${user.id.substring(0, 8)}', // Pseudo générique avec ID partiel pour éviter les collisions
            'email':
                '${user.id}@$domain', // Email générique avec domaine de l'entreprise pour garder les stats
            'avatar_url': null, // Suppression de l'avatar
            'etat_compte': 'ANONYMISE', // Marque le compte comme anonymisé
            'est_compte_valide':
                false, // Désactive le compte pour éviter toute connexion future
          })
          .eq('id', user.id);

      await supabaseClient.auth
          .signOut(); // Déconnexion de l'utilisateur après anonymisation
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateCredentials({String? email, String? password}) async {
    try {
      final user = currentUserSession?.user;
      if (user == null) {
        throw ServerException('User not logged in');
      }

      if (email == null && password == null) {
        throw ServerException('No credentials provided for update');
      }

      if (email != null) {
        await supabaseClient.auth.updateUser(UserAttributes(email: email));

        // Mise à jour de l'email dans la table utilisateur
        await supabaseClient
            .from('utilisateur')
            .update({'email': email})
            .eq('id', user.id);
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
