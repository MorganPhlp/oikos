import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/presentation/pages/pdf_viewer_page.dart';
import 'package:oikos/core/common/presentation/widgets/navbar.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:oikos/features/auth/presentation/pages/update_password_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_flow.dart';
import 'package:oikos/features/community/presentation/pages/community_dashboard_screen.dart';

import 'package:oikos/features/home/presentation/pages/home_page.dart';
import 'package:oikos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:oikos/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:oikos/features/profile/presentation/pages/profile_page.dart';

import 'features/codeBarre/domain/entities/aliment_entity.dart';
import 'features/codeBarre/presentation/pages/home_scan_page.dart';
import 'features/codeBarre/presentation/pages/product_details_page.dart';
import 'features/codeBarre/presentation/pages/scan_page.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/action_page.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/my_actions_page.dart';

GoRouter createRouter(AppUserCubit appUserCubit) {
  return GoRouter(
    initialLocation: '/',
    // On écoute le stream du Cubit pour relancer le redirect à chaque changement d'état
    refreshListenable: GoRouterRefreshStream(appUserCubit.stream),

    routes: [
      GoRoute(
        path: '/bilan',
        name: 'bilan',
        builder: (context, state) {
          final mode = state.extra as String? ?? 'full';
          return BilanFlow(mode: mode);
          },
      ),
      GoRoute(
        path: '/',
        name: 'intro',
        builder: (context, state) => const IntroPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
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
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => const UpdatePasswordPage(),
      ),

      ShellRoute(
        builder: (context, state, child) =>
            Scaffold(body: child, bottomNavigationBar: const OikosNavBar()),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/catalogue',
            name: 'catalogue',
            builder: (context, state) => const ActionsCataloguePage(),
          ),

          // 2. Route pour l'onglet "Actions" (Mes Actions en cours)
          GoRoute(
            path: '/my_actions',
            name: 'my_actions',
             builder: (context, state) => const MyActionsPage(),
          ),
          // route pour la page d'accueil du scan
          GoRoute(
            path: '/scan_intro',
            builder: (context, state) => const HomeScanPage(),
          ),
          // route pour la page de scan de code-barres
          GoRoute(
            path: '/scan',
            name: 'scan',
            builder: (context, state) => const ScanPage(),
          ),
          GoRoute( //Page de resultats d'un scan
            path: '/product_details',
            builder: (context, state) {
              // On récupère l'aliment passé en paramètre "extra"
              final aliment = state.extra as AlimentEntity;
              return ProductDetailsPage(aliment: aliment);
            },
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
          path: '/community',
          name: 'community',
          builder: (context, state) => const CommunityDashboardScreen(),
        ),
        ],
      ),
    ],

    redirect: (context, state) {
      final authState = context
          .read<AppUserCubit>()
          .state; // On récupère l'état de l'utilisateur
      final String location = state.uri.path;

      // 0. Si l'état n'est pas encore chargé, on attend
      if (authState is AppUserInitial) {
        return null;
      }

      final bool isResettingPassword = location.startsWith('/reset-password');

      // 1. CAS : UTILISATEUR NON CONNECTÉ
      // S'il essaye de réinitialiser le mot de passe
      if (isResettingPassword) {
        return null;
      }

      final bool isLoggedIn = authState is AppUserLoggedIn;

      // S'il n'est pas connecté et qu'il essaie d'aller ailleurs que sur l'intro
      if (!isLoggedIn) {
        return location == '/' ? null : '/';
      }

      // 2. CAS : UTILISATEUR CONNECTÉ
      // S'il est connecté mais qu'il est sur la page d'intro, on l'envoie vers l'appli
      if (isLoggedIn && location == '/') {
        return authState.user.hasCompletedBilan ? '/home' : '/bilan';
      }

      // L'utilisateur est connecté et va vers /home, /scan, /bilan... on laisse passer
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
