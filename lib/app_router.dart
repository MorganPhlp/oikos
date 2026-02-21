import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/presentation/pages/pdf_viewer_page.dart';
import 'package:oikos/core/common/presentation/widgets/header.dart';
import 'package:oikos/core/common/presentation/widgets/navbar.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/habitudes_cubit.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:oikos/features/auth/presentation/pages/update_password_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_flow.dart';
import 'package:oikos/features/community/presentation/pages/community_dashboard_screen.dart';

import 'package:oikos/features/home/presentation/pages/home_page.dart';
import 'package:oikos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:oikos/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:oikos/features/profile/presentation/pages/security_page.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:oikos/features/profile/presentation/pages/profile_page.dart';
import 'features/codeBarre/domain/entities/aliment_entity.dart';
import 'features/codeBarre/presentation/pages/home_scan_page.dart';
import 'features/codeBarre/presentation/pages/product_details_page.dart';
import 'features/codeBarre/presentation/pages/scan_page.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/action_page.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/my_actions_page.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/actions_bloc.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/actions_event.dart';

GoRouter createRouter(AppUserCubit appUserCubit) {
  GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(appUserCubit.stream),
    navigatorKey: rootNavigatorKey,

    routes: [
      GoRoute(
        path: '/',
        name: 'intro',
        builder: (context, state) => const IntroPage(),
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
            builder: (context, state) => const HomePage(),
          ),

          GoRoute(
            path: '/actions',
            name: 'catalogue',
            builder: (context, state) {
              final userId =
                  context.read<AppUserCubit>().state is AppUserLoggedIn
                  ? (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id
                  : '';

              final actionId = state.uri.queryParameters['actionId'];
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
                child: ActionsCataloguePage(openedActionId: actionId),
              );
            },
            routes: [
              GoRoute(
                path: 'mine', // /actions/mine
                name: 'my_actions',
                builder: (context, state) {
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
                            serviceLocator<HabitudeCubit>()
                              ..loadHabitudes(userId),
                      ),
                    ],
                    child: const MyActionsPage(),
                  );
                },
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
                  final aliment = state.extra as AlimentEntity;
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
          final args = state.extra as Map<String, String>;
          return PdfViewerPage(
            title: args['title']!,
            assetPath: args['assetPath']!,
          );
        },
      ),
    ],

    redirect: (context, state) {
      final authState = context.read<AppUserCubit>().state;
      final String location = state.uri.path;

      if (authState is AppUserInitial) return null;

      final bool isResettingPassword = location.startsWith('/reset-password');
      if (isResettingPassword) return null;

      final bool isLoggedIn = authState is AppUserLoggedIn;

      if (!isLoggedIn) {
        return location == '/' ? null : '/';
      }

      if (isLoggedIn && location == '/') {
        return authState.user.hasCompletedBilan ? '/home' : '/bilan';
      }

      return null;
    },
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
