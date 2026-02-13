import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit()
    : super(AppUserInitial()); // État initial sans utilisateur connecté

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserUnauthenticated()); // Pour gérer la déconnexion de l'utilisateur
    } else {
      emit(
        AppUserLoggedIn(user),
      ); // Met à jour l'état avec le nouvel utilisateur connecté
    }
  }
}
