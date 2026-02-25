import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/common/presentation/widgets/admin_scaffold.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/pages/community_management_page.dart';
import 'package:oikos/features/admin/presentation/pages/global_vue_page.dart';
import 'package:oikos/features/admin/presentation/pages/profil_page.dart';
import 'package:oikos/features/admin/presentation/pages/ranking_page.dart';
import 'package:oikos/features/admin/presentation/pages/users_page.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';

GoRouter createRouter(AppUserCubit appUserCubit) {
  return GoRouter(
    initialLocation: '/',
    // On écoute le stream du Cubit pour relancer le redirect à chaque changement d'état
    refreshListenable: GoRouterRefreshStream(appUserCubit.stream),

    routes: [
      GoRoute(
        path: '/',
        name: 'intro',
        builder: (context, state) => const IntroPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          // Liste des chemins pour faire correspondre l'URL à l'index
          final tabs = [
            '/admin/dashboard',
            '/admin/community',
            '/admin/ranking',
            '/admin/users',
            '/admin/profil',
          ];
          // On cherche l'index correspondant au chemin actuel
          final int currentIndex = tabs.indexWhere(
            (path) => state.uri.path.startsWith(path),
          );

          final brightness = MediaQuery.of(context).platformBrightness;
          final bool isDarkMode = brightness == Brightness.dark;
          return Theme(
            data: isDarkMode ? AdminTheme.darkTheme : AdminTheme.lightTheme,
            child: Builder(
              builder: (themeContext) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: Theme.of(
                      themeContext,
                    ).extension<GradientBackground>()?.gradient,
                  ),
                  child: Builder(
                    builder: (context) {
                      final state = context.watch<AppUserCubit>().state;
                      if (state is AppUserLoggedIn &&
                          state.user.isAdmin &&
                          state.company != null) {
                        Company company = state.company!;
                        return AdminScaffold(
                          logo: Image.network(company.logoNetworkUrl),
                          currentIndex: currentIndex < 0
                              ? 0
                              : currentIndex, // Sécurité si index non trouvé
                          destinations: [
                            NavigationDestination(
                              icon: Icon(Icons.dashboard_outlined),
                              selectedIcon: Icon(Icons.dashboard),
                              label: 'Vue Globale',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.people_outlined),
                              selectedIcon: const Icon(Icons.people),
                              label: 'Communautés',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.emoji_events_outlined),
                              selectedIcon: Icon(Icons.emoji_events),
                              label: 'Classement',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.person_outline),
                              selectedIcon: Icon(Icons.person),
                              label: 'Utilisateurs',
                            ),
                            NavigationDestination(
                              icon: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  state.user.avatarNetworkUrl,
                                ),
                              ),
                              selectedIcon: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  state.user.avatarNetworkUrl,
                                ),
                              ),
                              label: 'Profile',
                            ),
                          ],
                          onNavigationIndexChange: (index) {
                            // Au lieu de setState, on utilise GoRouter pour changer l'URL
                            if (index == 0) context.goNamed('adminDashboard');
                            if (index == 1) context.goNamed('adminCommunity');
                            if (index == 2) context.goNamed('adminRanking');
                            if (index == 3) context.goNamed('adminUsers');
                            if (index == 4) context.goNamed('adminProfil');
                          },
                          onLogout: () {
                            context.read<AuthBloc>().add(AuthLogout());
                          },
                          body:
                              child, // L'écran de la route actuelle injecté par GoRouter
                        );
                      }
                      return IntroPage(); // Fallback si jamais l'état n'est pas celui attendu
                    },
                  ),
                );
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            name: 'adminDashboard',
            builder: (context, state) {
              final appUserState = context.read<AppUserCubit>().state;

              if (appUserState is AppUserLoggedIn) {
                final Utilisateurs user = appUserState.user;
                final Company? company = appUserState.company;
                return GlobalVuePage(user: user, company: company!);
              }

              return const IntroPage();
            },
          ),
          GoRoute(
            path: '/admin/community',
            name: 'adminCommunity',
            builder: (context, state) {
              final appUserState = context.read<AppUserCubit>().state;

              if (appUserState is AppUserLoggedIn) {
                final Utilisateurs user = appUserState.user;
                final Company? company = appUserState.company;
                return CommunityManagementPage(user: user, company: company!);
              }
              return const IntroPage();
            },
          ),
          GoRoute(
            path: '/admin/profil',
            name: 'adminProfil',
            builder: (context, state) {
              final appUserState = context.read<AppUserCubit>().state;
              if (appUserState is AppUserLoggedIn) {
                final Utilisateurs user = appUserState.user;
                final Company? company = appUserState.company;
                return ProfilPage(user: user, company: company!);
              }
              return const IntroPage();
            },
          ),
          GoRoute(
            path: '/admin/ranking',
            name: 'adminRanking',
            builder: (context, state) {
              final appUserState = context.read<AppUserCubit>().state;
              if (appUserState is AppUserLoggedIn) {
                final Utilisateurs user = appUserState.user;
                final Company company = appUserState.company!;
                return RankingPage(user: user, company: company);
              }
              return const IntroPage();
            },
          ),
          GoRoute(
            path: '/admin/users',
            name: 'adminUsers',
            builder: (context, state) {
              final appUserState = context.read<AppUserCubit>().state;
              if (appUserState is AppUserLoggedIn) {
                final Utilisateurs user = appUserState.user;
                final Company company = appUserState.company!;
                return UsersPage(user: user, company: company);
              }
              return const IntroPage();
            },
          ),
        ],
      ),
    ],

    redirect: (context, state) {
      final authState = appUserCubit.state;
      final String location = state.matchedLocation;

      // 1. CAS : UTILISATEUR CONNECTÉ
      if (authState is AppUserLoggedIn) {
        // Si l'utilisateur est sur l'intro (/), on le redirige selon son rôle
        if (location == '/') {
          if (authState.user.isAdmin) {
            return '/admin/dashboard';
          }

          //ici se trouve normalement le Code pour rediriger vers la page utilisateur classique, mais je ne m'occupe que du dashboard admin donc on reste sur l'intro pour éviter les erreurs
          return null;
        }
        // Admin sur une route non-admin → forcer vers /admin/dashboard
        if (authState.user.isAdmin && !location.startsWith('/admin')) {
          return '/admin/dashboard';
        }
        return null;
      }

      // 2. CAS : UTILISATEUR NON CONNECTÉ
      // S'il n'est pas sur l'intro (/), on le force à y aller
      if (location != '/') {
        return '/';
      }

      return null;
    },
  );
}

// Classe utilitaire pour lier le Stream du Cubit au Listenable de GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
