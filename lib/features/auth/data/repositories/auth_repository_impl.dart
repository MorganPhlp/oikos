import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sup;
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      final sup.UserAttributes attributes = sup.UserAttributes(
        password: newPassword,
      );

      await remoteDataSource.client.auth.updateUser(attributes);

      return right(null);
    } on sup.AuthException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, Utilisateurs>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('Utilisateurs not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<String?> getUserId() async {
    final user = remoteDataSource.client.auth.currentUser;
    return user?.id;
  }

  @override
  Future<Either<Failure, Utilisateurs>> signInWithEmailPassword({
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
  Future<Either<Failure, Utilisateurs>> signUpWithEmailPassword({
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

  @override
  Future<Either<Failure, (String name, String? logoUrl)>> getCompanyByEmail({
    required String email,
  }) async {
    try {
      // Extraction du domaine
      final parts = email.split('@');
      if (parts.length != 2) {
        return left(Failure('Adresse email invalide.'));
      }
      final domain = parts[1];

      // Requête à la base de données
      final result = await remoteDataSource.client
          .from('entreprise')
          .select('nom, logo_url')
          .eq('domaine_email', domain)
          .maybeSingle();

      if (result == null) {
        return left(
          Failure('Aucune entreprise trouvée pour ce domaine email.'),
        );
      }

      final nom = result['nom'] as String;
      final logo = result['logo_url'] as String?;

      // Génération de l'URL publique du logo si disponible
      String? logoUrl;
      if (logo != null && logo.isNotEmpty) {
        logoUrl = remoteDataSource.client.storage
            .from('logos')
            .getPublicUrl(logo);
      }

      return right((nom, logoUrl));
    } on sup.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCommunityCode({
    required String communityCode,
  }) async {
    try {
      final result = await remoteDataSource.client
          .from('communaute')
          .select('nom')
          .eq('code', communityCode)
          .maybeSingle();

      if (result == null) {
        return left(Failure('Ce code communauté est invalide.'));
      }

      return right((result['nom'] as String));
    } on sup.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isPseudoUnique({required String pseudo}) async {
    try {
      final response = await remoteDataSource.client
          .from('utilisateur')
          .select('pseudo')
          .eq('pseudo', pseudo)
          .count(sup.CountOption.exact);

      final count = response.count;
      return right(count == 0);
    } on sup.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return right(null);
    } on sup.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Helper method to reduce code duplication
  Future<Either<Failure, Utilisateurs>> _getUser(
    Future<Utilisateurs> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on sup.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
