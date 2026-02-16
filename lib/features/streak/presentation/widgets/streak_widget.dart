import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_card_decoration.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_max_level_badge.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_progress_bar.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_visual_header.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_finished_view.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_details_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_empty_state.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_loading.dart';
import 'package:oikos/features/streak/presentation/widgets/countdown_badge.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_event.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakWidget extends StatefulWidget {
  const StreakWidget({super.key});

  @override
  State<StreakWidget> createState() => _StreakWidgetState();
}

class _StreakWidgetState extends State<StreakWidget> {
  bool isFlipped = false;
  bool showInfo = false;

  bool _hasNoSeason(StreakState state) =>
      state.streak.saisonNom == null || state.streak.saisonNom!.isEmpty;

  bool _canFlip(StreakState state) =>
      state is! StreakSeasonFinished && !_hasNoSeason(state);

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) => serviceLocator.get<StreakBloc>()
        ..add(
          WatchStreakEvent(
            userState.user.id,
            userState.user.entrepriseId ?? "",
          ),
        ),
      child: BlocBuilder<StreakBloc, StreakState>(
        builder: (context, state) {
          if (state is StreakLoading) {
            return StreakLoadingWidget(theme: Theme.of(context));
          }
          if (state is StreakSeasonFinished) {
            return StreakFinishedView(state: state);
          }
          if (state is StreakError) return const StreakEmptyState();

          return GestureDetector(
            onTap: _canFlip(state)
                ? () => setState(() => isFlipped = !isFlipped)
                : null,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: isFlipped ? 3.14159 : 0),
              duration: 600.ms,
              builder: (context, value, _) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Effet de perspective
                    ..rotateY(value),
                  child: value < (3.14159 / 2)
                      ? _buildFront(context, state)
                      : _buildBack(context),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront(BuildContext context, StreakState state) {
    final theme = Theme.of(context);

    final int maxPhase = state.streakSteps?.isNotEmpty == true
        ? state.streakSteps!.last.to
        : 0;
    final bool isMaxLevel =
        state.streak.currentStreak >= maxPhase && maxPhase > 0;

    final threshold = isMaxLevel
        ? 0
        : (state.streakSteps
                  ?.firstWhere(
                    (e) => e.from == state.streak.currentStreak,
                    orElse: () => state.streakSteps!.last,
                  )
                  .requiredActionsQuotidiennes ??
              0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        StreakCardDecoration(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                StreakVisualHeader(state: state),
                const SizedBox(height: 16),

                if (isMaxLevel)
                  const StreakMaxLevelBadge()
                else ...[
                  _buildCountdownBadge(state, theme),
                  const SizedBox(height: 20),
                  const DecorativeSeparator(),
                  const SizedBox(height: 20),
                  _buildInstructionText(theme),
                  const SizedBox(height: 20),
                  StreakProgressSection(state: state, threshold: threshold),
                ],
              ],
            ),
          ),
        ),
        _buildInfoButton(theme),
        if (showInfo) _buildInfoOverlay(theme),
      ],
    );
  }

  Widget _buildBack(BuildContext context) {
    final theme = Theme.of(context);
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateY(3.14159), // Inverse le flip pour le texte
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: StreakDetailsWidget(),
      ),
    );
  }

  Widget _buildCountdownBadge(StreakState state, ThemeData theme) =>
      CountdownBadge(
        targetDate: state.streak.saisonFin ?? DateTime.now(),
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        icon: Icon(
          LucideIcons.clock,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        onFinished: () =>
            context.read<StreakBloc>().add(const SeasonFinishedEvent()),
        prefix: '',
      );

  Widget _buildInstructionText(ThemeData theme) => Text(
    "pour réaliser ton action quotidienne et collective".toUpperCase(),
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 2.0,
      color: theme.colorScheme.primary.withValues(alpha: 0.9),
    ),
  );

  Widget _buildInfoButton(ThemeData theme) => Positioned(
    top: 12,
    right: 12,
    child: GestureDetector(
      onTap: () => setState(() => showInfo = !showInfo),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.helpCircle,
          size: 20,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
      ),
    ),
  );

  Widget _buildInfoOverlay(ThemeData theme) => Positioned(
    top: 55,
    right: 12,
    left: 12,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: const Column(
        children: [
          Text(
            "Comment ça marche ?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Complète tes actions pour faire fleurir ta fleur ! Clique dessus pour voir les étapes.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ).animate().fade().scale(begin: const Offset(0.95, 0.95)),
  );
}
