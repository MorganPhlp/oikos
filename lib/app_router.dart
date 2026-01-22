import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_flow.dart';

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
      // TO DO : ajouter les autres routes ici quand elles seront prêtes
      /*
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      */
    ],

    redirect: (context, state) {
      final authState = appUserCubit.state;
      final String location = state.matchedLocation;

      // 1. CAS : UTILISATEUR CONNECTÉ
      if (authState is AppUserLoggedIn) {
        // Si l'utilisateur est sur l'intro (/) ou les pages auth, on le redirige
        if (location == '/') {
          //TO DO : rediriger vers la home quand elle sera prête
          return authState.user.hasCompletedBilan ? '/' : '/bilan';
        }
      }

      // 2. CAS : UTILISATEUR NON CONNECTÉ
      // S'il n'est pas sur l'intro (/), on le force à y aller
      if (location != '/') {
        return '/';
      }

      return null; // Il est sur '/' et n'est pas connecté, c'est OK.
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