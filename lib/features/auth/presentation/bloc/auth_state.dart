part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

final class AuthCompanyInfoLoaded extends AuthState {
  final String companyName;
  final String? logoUrl;
  const AuthCompanyInfoLoaded({required this.companyName, this.logoUrl});
}

final class AuthCommunityVerified extends AuthState {
  final String communityName;
  const AuthCommunityVerified({required this.communityName});
}

final class AuthEmailPasswordVerified extends AuthState {}

final class AuthPseudoVerified extends AuthState {}