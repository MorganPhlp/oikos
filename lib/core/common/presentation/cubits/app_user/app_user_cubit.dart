import 'dart:async'; // Ajoute cet import
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final UtilisateurRepository _utilisateurRepository;
  StreamSubscription<UserEntity>? _userSubscription;

  AppUserCubit(this._utilisateurRepository) : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    if (user == null) {
      _userSubscription?.cancel();
      _userSubscription = null;
      emit(AppUserUnauthenticated());
    } else {
      emit(AppUserLoggedIn(user));
      _startListeningToUser(user.id);
    }
  }

  void _startListeningToUser(String userId) {
    _userSubscription?.cancel();
    _userSubscription = _utilisateurRepository.watchUser(userId).listen((
      updatedUser,
    ) {
      emit(AppUserLoggedIn(updatedUser));
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
