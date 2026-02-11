import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/streak/presentation/widgets/countdown_badge.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_event.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userState = context.read<AppUserCubit>().state;
    String userId = "";
    if (userState is AppUserLoggedIn) {
      userId = userState.user.id;
    }

    return BlocProvider(
      create: (context) =>
          serviceLocator.get<StreakBloc>()..add(WatchStreakEvent(userId)),
      child: BlocBuilder<StreakBloc, StreakState>(
        builder: (context, state) {
          final logoUrl = state.streak.logoUrl;
          final bool hasLogo = logoUrl != null && logoUrl.isNotEmpty;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (hasLogo)
                    Animate(
                      key: ValueKey('${logoUrl}_${state is StreakUpdated ? state.evolution : 'idle'}'),
                      effects: _buildEffects(state),
                      child: Image.network(
                        logoUrl,
                        height: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(delay: 900.ms, begin: 0, end: -10, duration: 2000.ms, curve: Curves.easeInOutSine),
                    )
                  else
                    const SizedBox(height: 140),

                  const SizedBox(height: 16),
                  
                  CountdownBadge(
                    targetDate: state.streak.lastUpdated.add(const Duration(days: 14)),
                    prefix: "",
                    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                    icon: Icon(LucideIcons.clock, size: 16, color: theme.colorScheme.primary),
                    backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                    borderColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                    onFinished: () {},
                  ),

                  const SizedBox(height: 20),
                  const _DecorativeSeparator(),
                  const SizedBox(height: 20),

                  Text(
                    "pour réaliser ton action quotidienne et collective".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: theme.colorScheme.primary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DecorativeSeparator extends StatelessWidget {
  const _DecorativeSeparator();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, color.withValues(alpha: 0.3)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.4), shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.3), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Effect> _buildEffects(StreakState state) {
  if (state is StreakUpdated && state.evolution == StreakEvolution.increase) {
    return [
      ScaleEffect(
        duration: 350.ms,
        curve: Curves.easeOutCubic,
        begin: const Offset(1, 1),
        end: const Offset(1.3, 1.3),
      ),
      ShimmerEffect(
        delay: 300.ms,
        duration: 500.ms,
        color: Colors.white.withValues(alpha: 0.6),
      ),
      ScaleEffect(
        delay: 350.ms,
        duration: 800.ms,
        curve: Curves.elasticOut,
        begin: const Offset(1.3, 1.3),
        end: const Offset(1, 1),
      ),
    ];
  }
  return [
    ScaleEffect(duration: 900.ms, curve: Curves.elasticOut, begin: const Offset(0, 0), end: const Offset(1, 1)),
    FadeEffect(duration: 400.ms),
  ];
}