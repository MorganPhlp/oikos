import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/app_router.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/core/app_bloc_observer.dart';

// Importe ici le fichier où tu as mis ton createRouter (ex: core/navigation/app_router.dart)
// import 'package:oikos/core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await initializeDateFormatting('fr_FR');
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<HomeBloc>()),
        BlocProvider(
          create: (context) => serviceLocator<CarbonFootPrintBloc>(),
        ),
        BlocProvider(create: (context) => serviceLocator<CommunityBloc>()),
        BlocProvider(create: (context) => serviceLocator<ProfileBloc>()),
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
    // 1. On vérifie si l'utilisateur est déjà loggé
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());

    // 2. On initialise le router en lui passant le Cubit
    // On utilise context.read car on a juste besoin de la référence
    _router = createRouter(context.read<AppUserCubit>());
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
