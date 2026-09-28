import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';

/// Retains a private URL while the persisted session is restored at startup.
class AuthRedirector {
  String? _pendingLocation;

  String? redirect(AppUserState state, String location) {
    if ((state is AppUserInitial || state is AppUserLoading) &&
        !['/', '/signup', '/reset-password', '/pdf'].contains(location)) {
      _pendingLocation ??= location;
    }
    if (state is AppUserUnauthenticated) {
      _pendingLocation = null;
    }
    if (state is AppUserLoggedIn && _pendingLocation != null) {
      final requested = _pendingLocation!;
      _pendingLocation = null;
      return authRedirect(state, requested) ?? requested;
    }
    return authRedirect(state, location);
  }
}

/// Shared access rules for mobile and administration; the database enforces rights.
String? authRedirect(AppUserState state, String location) {
  if (location == '/pdf' || location == '/reset-password') return null;
  if (state is! AppUserLoggedIn) {
    return location == '/' || location == '/signup' ? null : '/';
  }
  final home = state.user.isAdmin
      ? '/admin/dashboard'
      : state.user.hasCompletedBilan
      ? '/home'
      : '/bilan';
  if (location == '/' || location == '/signup') return home;
  if (location.startsWith('/admin') && !state.user.isAdmin) return home;
  if (state.user.isAdmin && !location.startsWith('/admin')) return home;
  return null;
}
