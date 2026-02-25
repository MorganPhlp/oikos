import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/domain/use_cases/get_company_info.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/auth/domain/usecases/current_user.dart';
import 'package:oikos/features/auth/domain/usecases/user_signin.dart';
import 'package:oikos/features/auth/domain/usecases/user_signup.dart';
import 'package:oikos/features/auth/domain/usecases/validate_email_password.dart';
import 'package:oikos/features/auth/domain/usecases/validate_pseudo.dart';

import '../../../../core/common/domain/usecase/usecase.dart';

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
  final GetCompanyInfo _getCompanyInfo;

  AuthBloc({
    required UserSignup userSignup,
    required UserSignin userSignin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required AuthRepository authRepository,
    required ValidateEmailPassword validateEmailPassword,
    required ValidatePseudo validatePseudo,
    required GetCompanyInfo getCompanyInfo,
  }) : _userSignin = userSignin,
       _userSignup = userSignup,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _authRepository = authRepository,
       _validateEmailPassword = validateEmailPassword,
       _validatePseudo = validatePseudo,
       _getCompanyInfo = getCompanyInfo,
       super(AuthInitial()) {
    // Suppression du handler global qui causait les bugs de chargement et d'erreurs
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
    on<AuthVerifyCommunity>(_onAuthVerifyCommunity);
    on<AuthLoadCompanyInfo>(_onAuthLoadCompanyInfo);
    on<AuthValidateEmailPassword>(_onAuthValidateEmailPassword);
    on<AuthValidatePseudo>(_onAuthValidatePseudo);
    on<AuthLogout>(_onAuthLogout);
    on<AuthUpdatePasswordRequested>(_onAuthChangePassword);
  }

  void _onAuthChangePassword(
    AuthUpdatePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _authRepository.updatePassword(event.newPassword);

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthPasswordUpdated()),
    );
  }

  void _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());

    await res.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async => await _emitAuthSuccess(user, emit),
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

    await res.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async => await _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignin(
      UserSigninParams(email: event.email, password: event.password),
    );

    await res.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async => await _emitAuthSuccess(user, emit),
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

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final res = await _authRepository.signOut();
    res.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    });
  }

  Future<void> _emitAuthSuccess(
    Utilisateurs user,
    Emitter<AuthState> emit,
  ) async {
    if (user.entrepriseId.isNotEmpty) {
      final companyRes = await _getCompanyInfo(user.entrepriseId);
      companyRes.fold(
        (_) => _appUserCubit.updateUser(user),
        (company) => _appUserCubit.updateUser(user, company: company),
      );
    } else {
      _appUserCubit.updateUser(user);
    }

    emit(AuthSuccess(user));
  }
}
