part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String pseudo;
  final String communityCode;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.pseudo,
    required this.communityCode,
  });
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthResetState extends AuthEvent {}

final class AuthLoadCompanyInfo extends AuthEvent {
  final String email;

  AuthLoadCompanyInfo({required this.email});
}

final class AuthVerifyCommunity extends AuthEvent {
  final String communityCode;

  AuthVerifyCommunity({required this.communityCode});
}

final class AuthValidateEmailPassword extends AuthEvent {
  final String email;
  final String password;

  AuthValidateEmailPassword({required this.email, required this.password});
}

final class AuthValidatePseudo extends AuthEvent {
  final String pseudo;

  AuthValidatePseudo({required this.pseudo});
}

final class AuthSignOut extends AuthEvent {}

final class AuthResetPassword extends AuthEvent {
  final String email;

  AuthResetPassword({required this.email});
}

final class AuthUpdateUser extends AuthEvent {
  final String? pseudo;
  final String? avatar;

  AuthUpdateUser({this.pseudo, this.avatar});
}

final class AuthDeleteAccount extends AuthEvent {}