import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/routing/auth_redirect.dart';
import 'package:oikos/features/admin/domain/interfaces/company_rep.dart';
import 'package:oikos/features/admin/domain/models/models.dart';
import 'package:oikos/features/auth/data/models/user_model.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/usecases/validate_email_password.dart';

const member = UserEntity(
  id: 'member',
  email: 'alice@oikos.test',
  pseudo: 'Alice',
  communityCode: 'DEMO01',
  entrepriseId: 'company',
);
const company = Company(
  id: 'company',
  name: 'Demo',
  logoUrl: null,
  domainEmail: 'oikos.test',
  description: 'Demo',
);

class UsersFake implements UtilisateurRepository {
  final updates = StreamController<UserEntity>.broadcast();
  @override
  Stream<UserEntity> watchUser(String id) => updates.stream;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CompaniesFake implements CompanyRep {
  final response = Completer<Either<Failure, Company>>();
  @override
  Future<Either<Failure, Company>> getCompanyData(String id) => response.future;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SignupFake implements AuthRepository {
  int companyCalls = 0;
  @override
  Future<Either<Failure, (String, String?)>> getCompanyByEmail({
    required String email,
  }) async {
    companyCalls++;
    return right(('Demo', null));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected call ${invocation.memberName}');
}

void main() {
  test('restoring a session retains its URL and still enforces the role', () {
    final redirector = AuthRedirector();
    expect(redirector.redirect(AppUserInitial(), '/actions/mine'), '/');
    expect(redirector.redirect(AppUserLoggedIn(member), '/'), '/actions/mine');
    expect(
      redirector.redirect(AppUserLoggedIn(member), '/actions/mine'),
      isNull,
    );
    expect(redirector.redirect(AppUserInitial(), '/admin/users'), '/');
    expect(redirector.redirect(AppUserLoggedIn(member), '/'), '/bilan');
    expect(redirector.redirect(AppUserInitial(), '/actions/mine'), '/');
    redirector.redirect(AppUserUnauthenticated(), '/');
    expect(redirector.redirect(AppUserLoggedIn(member), '/'), '/bilan');
  });
  test('profile decoding preserves admin role and onboarding state', () {
    final user = UserModel.fromJson({
      'id': 'admin',
      'role': 'ADMINISTRATEUR',
      'entreprise_id': 'company',
      'a_complete_bilan': true,
      'etat_compte': 'ACTIF',
      'est_compte_valide': true,
    });
    expect(user.isAdmin, isTrue);
    expect(user.hasCompletedBilan, isTrue);
    expect(user.entrepriseId, 'company');
    expect(user.copyWith(etatCompte: EtatCompte.anonymise).canSignIn, isFalse);
    expect(user.copyWith(estCompteValide: false).canSignIn, isFalse);
    expect(
      member.copyWith(isActive: false).canSignIn,
      isTrue,
      reason: 'Voluntary pause does not delete the account',
    );
  });
  test('routing preserves mobile, onboarding, admin and password recovery', () {
    expect(authRedirect(AppUserUnauthenticated(), '/admin/users'), '/');
    expect(authRedirect(AppUserUnauthenticated(), '/signup'), isNull);
    expect(authRedirect(AppUserLoggedIn(member), '/'), '/bilan');
    expect(
      authRedirect(
        AppUserLoggedIn(member.copyWith(hasCompletedBilan: true)),
        '/admin/users',
      ),
      '/home',
    );
    final admin = AppUserLoggedIn(
      member.copyWith(role: RoleUtilisateur.administrateur),
      company,
    );
    expect(authRedirect(admin, '/home'), '/admin/dashboard');
    expect(authRedirect(admin, '/admin/users'), isNull);
    expect(authRedirect(admin, '/reset-password'), isNull);
  });
  test('logout wins over an in-flight admin company request', () async {
    final users = UsersFake();
    final companies = CompaniesFake();
    final cubit = AppUserCubit(users, companies);
    final pending = cubit.updateUser(
      member.copyWith(role: RoleUtilisateur.administrateur),
    );
    await Future<void>.delayed(Duration.zero);
    await cubit.updateUser(null);
    companies.response.complete(right(company));
    await pending;
    expect(cubit.state, isA<AppUserUnauthenticated>());
    expect(users.updates.hasListener, isFalse);
    await cubit.close();
    await users.updates.close();
  });
  test(
    'realtime profile updates and revocation reach the shared session',
    () async {
      final users = UsersFake();
      final cubit = AppUserCubit(users, CompaniesFake());
      await cubit.updateUser(member);
      users.updates.add(member.copyWith(hasCompletedBilan: true));
      await Future<void>.delayed(Duration.zero);
      expect((cubit.state as AppUserLoggedIn).user.hasCompletedBilan, isTrue);
      users.updates.add(member.copyWith(etatCompte: EtatCompte.anonymise));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<AppUserUnauthenticated>());
      await cubit.close();
      expect(users.updates.hasListener, isFalse);
      await users.updates.close();
    },
  );
  test('signup validates without querying other users emails', () async {
    final repo = SignupFake();
    final useCase = ValidateEmailPassword(repo);
    final valid = await useCase(
      ValidateEmailPasswordParams(
        email: 'alice@oikos.test',
        password: 'OikosLocal123!',
      ),
    );
    expect(valid.isRight(), isTrue);
    expect(repo.companyCalls, 1);
    final invalid = await useCase(
      ValidateEmailPasswordParams(email: 'invalid', password: 'x'),
    );
    expect(invalid.isLeft(), isTrue);
    expect(repo.companyCalls, 1);
  });
}
