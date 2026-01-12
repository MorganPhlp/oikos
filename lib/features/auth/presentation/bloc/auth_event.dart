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

final class AuthLoadCompanyInfo extends AuthEvent {
  final String email;

  AuthLoadCompanyInfo({required this.email});
}

final class AuthVerifyCommunity extends AuthEvent {
  final String communityCode;

  AuthVerifyCommunity({required this.communityCode});
}
