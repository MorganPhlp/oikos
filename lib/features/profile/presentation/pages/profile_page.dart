import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_bilan_section.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_account_section.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_danger_section.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = 'profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Simule les questions restantes (TODO : à connecter plus tard au BilanSessionBloc)
  final int _remainingQuestions = 12;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // La redirection de déconnexion est gérée par le router via AppUserCubit
        // On garde le listener si on veut gérer d'autres états (erreurs spécifiques, loading, etc.)
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              const ProfileTopBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      ProfileHeaderCard(),

                      const SizedBox(height: 25),

                      ProfileBilanSection(remainingQuestions: _remainingQuestions),

                      const SizedBox(height: 25),

                      const ProfileAccountSection(),

                      const SizedBox(height: 25),

                      const ProfileDangerSection(),

                      const SizedBox(height: 40),
                      Text(
                        'Version 1.0.0 • © 2026 Oîkos',
                        style: AppTypography.body.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}