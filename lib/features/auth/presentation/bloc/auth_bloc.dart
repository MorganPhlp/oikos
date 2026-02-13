import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/usecases/current_user.dart';
import 'package:oikos/features/auth/domain/usecases/delete_account.dart';
import 'package:oikos/features/auth/domain/usecases/reset_password.dart';
import 'package:oikos/features/auth/domain/usecases/update_user.dart';
import 'package:oikos/features/auth/domain/usecases/user_signin.dart';
import 'package:oikos/features/auth/domain/usecases/user_signout.dart';
import 'package:oikos/features/auth/domain/usecases/user_signup.dart';
import 'package:oikos/features/auth/domain/usecases/validate_email_password.dart';
import 'package:oikos/features/auth/domain/usecases/validate_pseudo.dart';

import '../../../../core/usecase/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserSignin _userSignin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final AuthRepository _authRepository;
  final ValidateEmailPassword _validateEmailPassword;
  final ValidatePseudo _validatePseudo;
  final UserSignOut _userSignOut;
  final ResetPassword _resetPassword;
  final UpdateUser _updateUser;
  final DeleteAccount _deleteAccount;

  AuthBloc({
    required UserSignup userSignup,
    required UserSignin userSignin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required AuthRepository authRepository,
    required ValidateEmailPassword validateEmailPassword,
    required ValidatePseudo validatePseudo,
    required UserSignOut userSignOut,
    required ResetPassword resetPassword,
    required UpdateUser updateUser,
    required DeleteAccount deleteAccount,
  }) : _userSignin = userSignin,
       _userSignup = userSignup,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _authRepository = authRepository,
       _validateEmailPassword = validateEmailPassword,
       _validatePseudo = validatePseudo,
       _userSignOut = userSignOut,
       _resetPassword = resetPassword,
       _updateUser = updateUser,
       _deleteAccount = deleteAccount,
       super(AuthInitial()) {

    on<AuthResetState>((event, emit) => emit(AuthInitial()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
    on<AuthVerifyCommunity>(_onAuthVerifyCommunity);
    on<AuthLoadCompanyInfo>(_onAuthLoadCompanyInfo);
    on<AuthValidateEmailPassword>(_onAuthValidateEmailPassword);
    on<AuthValidatePseudo>(_onAuthValidatePseudo);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthResetPassword>(_onAuthResetPassword);
    on<AuthUpdateUser>(_onAuthUpdateUser);
    on<AuthDeleteAccount>(_onAuthDeleteAccount);
  }

  void _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignup(
      UserSignupParams(
        email: event.email,
        password: event.password,
        pseudo: event.pseudo,
        communityCode: event.communityCode,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    final res = await _userSignOut(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      //on vide le Cubit Utilisateur
      // Le Router va détecter le changement et rediriger vers '/'
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    });
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignin(
      UserSigninParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLoadCompanyInfo(
    AuthLoadCompanyInfo event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _authRepository.getCompanyByEmail(email: event.email);

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (companyData) => emit(
        AuthCompanyInfoLoaded(
          companyName: companyData.$1,
          logoUrl: companyData.$2,
        ),
      ),
    );
  }

  void _onAuthVerifyCommunity(
    AuthVerifyCommunity event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _authRepository.verifyCommunityCode(
      communityCode: event.communityCode,
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (communityName) =>
          emit(AuthCommunityVerified(communityName: communityName)),
    );
  }

  void _onAuthValidateEmailPassword(
    AuthValidateEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _validateEmailPassword(
      ValidateEmailPasswordParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthEmailPasswordVerified()),
    );
  }

  void _onAuthValidatePseudo(
    AuthValidatePseudo event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _validatePseudo(event.pseudo);

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthPseudoVerified()),
    );
  }

  void _onAuthResetPassword(
    AuthResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _resetPassword(event.email);

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthPasswordResetSent()),
    );
  }

  void _onAuthUpdateUser(
    AuthUpdateUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _updateUser(
      UpdateUserParams(pseudo: event.pseudo, avatar: event.avatar),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthDeleteAccount(
    AuthDeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _deleteAccount(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        // On vide le Cubit Utilisateur comme lors d'une déconnexion normale
        // Le Router va détecter le changement et rediriger vers '/'
        _appUserCubit.updateUser(null);
        emit(AuthInitial());
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
