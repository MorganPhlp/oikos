import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/core/logger.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit()
    : super(AppUserInitial()); // État initial sans utilisateur connecté

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial()); // Pour gérer la déconnexion de l'utilisateur
    } else {
      logger.i(
        user.isAdmin
            ? 'Utilisateur administrateur connecté'
            : 'Utilisateur connecté',
      );
      emit(
        AppUserLoggedIn(user),
      ); // Met à jour l'état avec le nouvel utilisateur connecté
    }
  }
}
