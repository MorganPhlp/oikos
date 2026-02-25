import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/home/presentation/bloc/home_stats_cubit.dart';
import 'package:oikos/features/home/presentation/bloc/home_stats_state.dart';
import 'package:oikos/features/home/presentation/widgets/quick_access_widget.dart';
import 'package:oikos/features/home/presentation/widgets/stats_caroussel_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<AppUserCubit>().state;
    if (state is! AppUserLoggedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final user = state.user;
    final entrepriseId = user.entrepriseId;
    final myCommunityCode = user.communityCode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  StreakWidget(),
                  const SizedBox(height: 32),

                  BlocBuilder<HomeStatsCubit, HomeStatsState>(
                    builder: (context, statsState) {
                      if (statsState is HomeStatsLoading) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (statsState is HomeStatsLoaded) {
                        return StatsCarousselWidget(
                          allStatsCards: statsState.statsCards,
                        );
                      }
                      if (statsState is HomeStatsError) {
                        return SizedBox(
                          height: 160,
                          child: Center(
                            child: Text(
                              'Impossible de charger les stats',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 32),
                  const QuickAccessWidget(),
                  const SizedBox(height: 32),
                  if (entrepriseId != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ta communauté a besoin de toi !",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ActionsCommunautairesWidget(
                    //   myCommunityCode: myCommunityCode,
                    // ),
                  ] else
                    const Text("Rejoignez une communauté pour voir les défis"),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
