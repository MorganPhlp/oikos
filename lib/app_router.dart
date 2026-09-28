import 'package:oikos/core/routing/auth_redirect.dart';
import 'package:oikos/core/common/presentation/extensions/asset_urls.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/common/presentation/widgets/admin_scaffold.dart';
import 'package:oikos/features/admin/domain/models/models.dart';
import 'package:oikos/features/admin/presentation/pages/community_management_page.dart';
import 'package:oikos/features/admin/presentation/pages/global_vue_page.dart';
import 'package:oikos/features/admin/presentation/pages/profil_page.dart';
import 'package:oikos/features/admin/presentation/pages/ranking_page.dart';
import 'package:oikos/features/admin/presentation/pages/users_page.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/presentation/pages/pdf_viewer_page.dart';
import 'package:oikos/core/common/presentation/widgets/header.dart';
import 'package:oikos/core/common/presentation/widgets/navbar.dart';
import 'package:oikos/features/actions/presentation/bloc/habitudes_cubit.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:oikos/features/auth/presentation/pages/signup_page.dart';
import 'package:oikos/features/auth/presentation/pages/update_password_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_flow.dart';
import 'package:oikos/features/community/presentation/pages/community_dashboard_screen.dart';

import 'package:oikos/features/home/presentation/pages/home_page.dart';
import 'package:oikos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:oikos/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:oikos/features/notifications/presentation/pages/notifications_page.dart';
import 'package:oikos/features/profile/presentation/pages/security_page.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:oikos/features/profile/presentation/pages/profile_page.dart';
import 'features/codeBarre/domain/entities/aliment_entity.dart';
import 'features/codeBarre/presentation/pages/home_scan_page.dart';
import 'features/codeBarre/presentation/pages/product_details_page.dart';
import 'features/codeBarre/presentation/pages/scan_page.dart';
import 'package:oikos/features/actions/presentation/pages/action_page.dart';
import 'package:oikos/features/actions/presentation/pages/my_actions_page.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_bloc.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_event.dart';
import 'package:oikos/features/home/presentation/bloc/home_stats_cubit.dart';

GoRouter createRouter(
  AppUserCubit appUserCubit, {
  required Listenable refreshListenable,
}) {
  GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
  final redirector = AuthRedirector();

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    navigatorKey: rootNavigatorKey,

    routes: [
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

          return Builder(
            builder: (context) {
              final state = context.watch<AppUserCubit>().state;
              if (state is AppUserLoggedIn &&
                  state.user.isAdmin &&
                  state.company != null) {
                Company company = state.company!;
                return AdminScaffold(
                  logo: Image.network(company.logoNetworkUrl),
                  currentIndex: currentIndex < 0 ? 0 : currentIndex,
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
                    if (index == 0) context.goNamed('adminDashboard');
                    if (index == 1) context.goNamed('adminCommunity');
                    if (index == 2) context.goNamed('adminRanking');
                    if (index == 3) context.goNamed('adminUsers');
                    if (index == 4) context.goNamed('adminProfil');
                  },
                  onLogout: () {
                    context.read<AuthBloc>().add(AuthSignOut());
                  },
                  body: child,
                );
              }
              return IntroPage();
            },
          );
        },
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            name: 'adminDashboard',
            builder: (context, state) {
              final appUserState = context.read<AppUserCubit>().state;

              if (appUserState is AppUserLoggedIn) {
                final UserEntity user = appUserState.user;
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
                final UserEntity user = appUserState.user;
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
                final UserEntity user = appUserState.user;
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
                final UserEntity user = appUserState.user;
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
                final UserEntity user = appUserState.user;
                final Company company = appUserState.company!;
                return UsersPage(user: user, company: company);
              }
              return const IntroPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        name: 'intro',
        builder: (context, state) => const IntroPage(),
      ),

      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),

      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => const UpdatePasswordPage(),
      ),

      GoRoute(
        path: '/bilan',
        name: 'bilan',
        builder: (context, state) {
          final mode = state.extra as String? ?? 'full';
          return BilanFlow(mode: mode);
        },
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
        routes: [
          GoRoute(
            path: 'security', // /profile/security
            name: 'security',
            builder: (context, state) => const SecurityPage(),
          ),
        ],
      ),

      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (context) => serviceLocator<DashboardBloc>(),
            child: const DashboardPage(),
          ),
        ),
      ),

      GoRoute(
        path: '/notifications',
        name: 'notifications',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            child: const NotificationsPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Animation du flou (on part de 10 pour finir à 0 quand la page est là)

              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: child,
                  );
                },
                child: child,
              );
            },
          );
        },
      ),

      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: const OikosNavBar(),
          appBar: const Header(),
        ),
        routes: [
          // 1. Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) {
              final userId =
                  context.read<AppUserCubit>().state is AppUserLoggedIn
                  ? (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id
                  : '';
              return BlocProvider(
                create: (context) =>
                    serviceLocator<HomeStatsCubit>()..loadStats(userId),
                child: const HomePage(),
              );
            },
          ),
          ShellRoute(
            builder: (context, state, child) {
              final userId =
                  context.read<AppUserCubit>().state is AppUserLoggedIn
                  ? (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id
                  : '';
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        serviceLocator<ActionsBloc>()
                          ..add(LoadAllActionsEvent(userId)),
                  ),
                  BlocProvider(
                    create: (_) =>
                        serviceLocator<HabitudeCubit>()..loadHabitudes(userId),
                  ),
                ],
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/actions',
                name: 'catalogue',
                builder: (context, state) {
                  final actionId = state.uri.queryParameters['actionId'];
                  return ActionsCataloguePage(openedActionId: actionId);
                },
                routes: [
                  GoRoute(
                    path: 'mine', // /actions/mine
                    name: 'my_actions',
                    builder: (context, state) {
                      return const MyActionsPage();
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/scan',
            name: 'scan_intro',
            builder: (context, state) => const HomeScanPage(),
            routes: [
              GoRoute(
                path: 'camera', // /scan/camera
                name: 'scan',
                builder: (context, state) => const ScanPage(),
              ),
              GoRoute(
                path: 'details', // /scan/details
                name: 'product_details',
                builder: (context, state) {
                  final aliment = state.extra;
                  if (aliment is! AlimentEntity) return const HomeScanPage();
                  return ProductDetailsPage(aliment: aliment);
                },
              ),
            ],
          ),

          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const CommunityDashboardScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/pdf',
        name: 'pdf_viewer',
        builder: (context, state) {
          final args = state.extra;
          if (args is! Map<String, String> ||
              args['title'] == null ||
              args['assetPath'] == null) {
            {
              return const IntroPage();
            }
          }
          return PdfViewerPage(
            title: args['title']!,
            assetPath: args['assetPath']!,
          );
        },
      ),
    ],

    redirect: (context, state) =>
        redirector.redirect(appUserCubit.state, state.uri.path),
  );
}

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
