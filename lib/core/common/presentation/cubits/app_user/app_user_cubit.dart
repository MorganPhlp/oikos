import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';
import 'package:oikos/features/admin/domain/interfaces/company_rep.dart';
import 'package:oikos/features/admin/domain/models/models.dart';
part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit(this._users, this._companies) : super(AppUserInitial());
  final UtilisateurRepository _users;
  final CompanyRep _companies;
  StreamSubscription<UserEntity>? _subscription;
  int _revision = 0;

  Future<void> updateUser(UserEntity? user) async {
    final revision = ++_revision;
    await _subscription?.cancel();
    _subscription = null;
    if (isClosed || revision != _revision) return;
    if (user == null || !user.canSignIn) {
      emit(AppUserUnauthenticated());
      return;
    }
    Company? company;
    if (user.isAdmin) {
      final result = await _companies.getCompanyData(user.entrepriseId);
      if (isClosed || revision != _revision) return;
      company = result.fold((_) => null, (value) => value);
      if (company == null) {
        emit(AppUserUnauthenticated());
        return;
      }
    }
    emit(AppUserLoggedIn(user, company));
    _subscription = _users
        .watchUser(user.id)
        .listen(
          (updated) {
            if (isClosed || revision != _revision) return;
            if (!updated.canSignIn ||
                updated.role != user.role ||
                updated.entrepriseId != user.entrepriseId) {
              unawaited(updateUser(updated));
            } else {
              emit(AppUserLoggedIn(updated, company));
            }
          },
          onError: (Object error, StackTrace stack) {
            // Keep the last known profile during temporary realtime interruptions.
            addError(error, stack);
          },
        );
  }

  @override
  Future<void> close() async {
    _revision++;
    await _subscription?.cancel();
    return super.close();
  }
}
