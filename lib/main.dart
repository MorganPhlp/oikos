import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/app_router.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/cubits/theme/theme_cubit.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/core/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await initializeDateFormatting('fr_FR');
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
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
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    _router = createRouter(context.read<AppUserCubit>());
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder écoute ThemeCubit → reconstruit uniquement MaterialApp
    // quand le mode change (minimal rebuild surface).
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Oîkos',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}
