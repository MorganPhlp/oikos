import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:oikos/app_router.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy(); // Pour ne pas avoir de # dans les URLs

  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<HomeBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // On déclare le router en late pour l'initialiser une seule fois
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) { // 1. On écoute les changements d'état d'authentification de Supabase
      final session = data.session;
      final event = data.event;

      if(event == AuthChangeEvent.tokenRefreshed){
        return; // On ignore les événements de rafraîchissement de token pour éviter les boucles infinies
      }

      if(event == AuthChangeEvent.signedOut){
        serviceLocator<AppUserCubit>().updateUser(null); // On efface les données de l'utilisateur du Cubit à la déconnexion
        return;
      }

      if(session != null && mounted){ // Si une session existe, on met à jour le Cubit avec les données de l'utilisateur
        if(event == AuthChangeEvent.initialSession){
          serviceLocator<AuthBloc>().add(AuthIsUserLoggedIn()); // On vérifie si l'utilisateur est connecté à chaque changement d'état d'authentification
        }
      }
    });

    // 2. On initialise le router avec le singleton AppUserCubit DIRECTEMENT
    // C'est la source de vérité unique
    _router = createRouter(serviceLocator<AppUserCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Oîkos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // On utilise routerConfig pour brancher GoRouter
      routerConfig: _router, 
    );
  }
}