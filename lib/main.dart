import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_flow.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_page.dart';
import 'package:oikos/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugin services are initialized
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

// Passage de StatelessWidget à StatefulWidget pour gérer l'état
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oîkos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            // Si l'utilisateur est connecté, afficher le bilan
            return const BilanFlow();
          } else {
            // Sinon, afficher la page d'introduction ou de connexion
            return const IntroPage(); // Remplacez par votre page d'introduction
          }
        },
      ),
    );
  }
}
