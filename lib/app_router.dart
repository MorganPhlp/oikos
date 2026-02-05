import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/presentation/pages/pdf_viewer_page.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_flow.dart';
import 'package:oikos/features/dashboard/presentation/pages/home_page.dart';
import 'features/codeBarre/presentation/pages/scan_page.dart';

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
      GoRoute(
        path: '/bilan',
        name: 'bilan',
        builder: (context, state) => const BilanFlow(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // route pour la page de scan de code-barres
      GoRoute(
        path: '/scan',
        name: 'scan',
        builder: (context, state) => const ScanPage(),
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
      final authState = appUserCubit.state;
      final String location = state.matchedLocation;

      // 0. Si l'état n'est pas encore chargé, on attend
      if (authState is AppUserInitial) {
        return null;
      }

      final bool isLoggedIn = authState is AppUserLoggedIn;

      // 1. CAS : UTILISATEUR NON CONNECTÉ
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
