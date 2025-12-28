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