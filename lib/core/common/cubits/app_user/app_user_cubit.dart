import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/features/admin/data/models/models.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit()
    : super(AppUserInitial()); // État initial sans utilisateur connecté

  void updateUser(Utilisateurs? user, {Company? company}) {
    if (user == null) {
      emit(AppUserInitial()); // Pour gérer la déconnexion de l'utilisateur
    } else {
      logger.i(
        user.isAdmin
            ? 'Utilisateur administrateur connecté'
            : 'Utilisateur connecté',
      );
      emit(
        AppUserLoggedIn(user, company),
      ); // Met à jour l'état avec le nouvel utilisateur connecté
    }
  }
}
