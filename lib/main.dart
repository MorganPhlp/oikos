import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/secrets/app_secrets.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:oikos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:oikos/features/auth/domain/usecases/user_signup.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/auth/presentation/pages/intro_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugin services are initialized
  final supabase = await Supabase.initialize(
    // Initialize Supabase
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignup: UserSignup(
              AuthRepositoryImpl(
                supabaseClient: supabase.client,
                remoteDataSource: AuthRemoteDataSourceImpl(
                  supabaseClient: supabase.client,
                ),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oîkos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const IntroPage(),
    );
  }
}
