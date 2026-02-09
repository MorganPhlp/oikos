import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  // 👇 MODIFICATION ICI : On démarre directement en état "Connecté"
  AppUserCubit() : super(
    AppUserLoggedIn(
      User(
        id: '723fe6bf-1790-43d1-ba85-b2fab15c98f7',
        email: '723fe6bf-1790-43d1-ba85-b2fab15c98f7@viveris.fr',
        pseudo: 'Anonyme-723fe6bf',
        communityCode: 'VIV123', // ✅ C'est ça qui débloque ta page !
        // Ajoute ici des valeurs par défaut pour éviter les erreurs "Null" :
        hasCompletedBilan: true,
      ),
    ),
  ); 

  void updateUser(User? user) {
    if(user == null) {
      emit(AppUserInitial()); 
    } else {
      emit(AppUserLoggedIn(user)); 
    }
  }
}

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial()); // État initial sans utilisateur connecté

  void updateUser(User? user) {
    if(user == null) {
      emit(AppUserInitial()); // Pour gérer la déconnexion de l'utilisateur
    } else {
      emit(AppUserLoggedIn(user)); // Met à jour l'état avec le nouvel utilisateur connecté
    }
  }
  
}*/
