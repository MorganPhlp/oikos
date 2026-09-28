import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<SessionChange> get sessionChanges => remoteDataSource
      .client
      .auth
      .onAuthStateChange
      .where(
        (state) => [
          AuthChangeEvent.signedIn,
          AuthChangeEvent.signedOut,
          AuthChangeEvent.passwordRecovery,
        ].contains(state.event),
      )
      .map(
        (state) => switch (state.event) {
          AuthChangeEvent.signedOut => SessionChange.signedOut,
          AuthChangeEvent.passwordRecovery => SessionChange.passwordRecovery,
          _ => SessionChange.signedIn,
        },
      );

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  @override
  Future<String?> getUserId() async {
    final user = remoteDataSource.client.auth.currentUser;
    return user?.id;
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailPassword({
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
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
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
      final result = await remoteDataSource.client.rpc(
        'lookup_company',
        params: {'email_domain': domain},
      );

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
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCommunityCode({
    required String communityCode,
  }) async {
    try {
      final result = await remoteDataSource.client.rpc(
        'lookup_community',
        params: {'community_code': communityCode},
      );

      if (result == null) {
        return left(Failure('Ce code communauté est invalide.'));
      }

      return right((result['nom'] as String));
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  @override
  Future<Either<Failure, bool>> isPseudoUnique({required String pseudo}) async {
    try {
      final available = await remoteDataSource.client.rpc(
        'pseudo_available',
        params: {'candidate': pseudo},
      );
      return right(available as bool);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  // Helper method to reduce code duplication
  Future<Either<Failure, UserEntity>> _getUser(
    Future<UserEntity> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // On utilise le client accessible via la remoteDataSource
      await remoteDataSource.client.auth.signOut();

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    String? pseudo,
    String? avatar,
    bool? isActive,
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateUserData(
        pseudo: pseudo,
        avatar: avatar,
        isActive: isActive,
      );
      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.anonymizeAccount();
      return const Right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCredentials({
    String? email,
    String? password,
    String? currentPassword,
  }) async {
    try {
      await remoteDataSource.updateCredentials(
        email: email,
        password: password,
        currentPassword: currentPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException {
      return left(Failure('Impossible de contacter le service. Réessaie.'));
    }
  }
}
