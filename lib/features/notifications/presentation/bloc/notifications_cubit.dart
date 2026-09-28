import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/notifications/domain/usecases/mark_as_read_use_case.dart';
import 'package:oikos/features/notifications/domain/usecases/watch_notifications_use_case.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final AppUserCubit _appUserCubit;
  final MarkAsReadUseCase _markAsReadUseCase;
  final WatchNotificationsUseCase _watchNotificationsUseCase;

  StreamSubscription? _notifSubscription;
  StreamSubscription? _authSubscription;

  NotificationsCubit({
    required AppUserCubit appUserCubit,
    required MarkAsReadUseCase markAsReadUseCase,
    required WatchNotificationsUseCase watchNotificationsUseCase,
  }) : _appUserCubit = appUserCubit,
       _markAsReadUseCase = markAsReadUseCase,
       _watchNotificationsUseCase = watchNotificationsUseCase,
       super(NotificationsState.initial()) {
    // 1. On écoute les changements d'auth immédiatement
    _authSubscription = _appUserCubit.stream.listen((authState) {
      if (authState is AppUserLoggedIn) {
        _startWatching(authState.user.id);
      } else {
        _stopWatching();
      }
    });

    // 2. Cas particulier : si l'utilisateur est DÉJÀ connecté au moment du boot
    if (_appUserCubit.state is AppUserLoggedIn) {
      _startWatching((_appUserCubit.state as AppUserLoggedIn).user.id);
    }
  }

  void _startWatching(String userId) {
    emit(state.copyWith(isLoading: true));
    _notifSubscription?.cancel();

    _notifSubscription = _watchNotificationsUseCase(userId).listen((
      notifications,
    ) {
      emit(state.copyWith(notifications: notifications, isLoading: false));
    }, onError: (error) => emit(state.copyWith(isLoading: false)));
  }

  void _stopWatching() {
    _notifSubscription?.cancel();
    emit(NotificationsState.initial());
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _markAsReadUseCase(notificationId);
    result.fold((failure) => null, (_) => null);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _notifSubscription?.cancel();
    return super.close();
  }
}
