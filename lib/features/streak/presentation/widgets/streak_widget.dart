import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_card_decoration.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_congrats_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_loss_widget.dart';
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
  bool _isResetting = false;
  late StreakBloc _streakBloc;

  @override
  void initState() {
    super.initState();
    _streakBloc = serviceLocator.get<StreakBloc>();
    _initWatch();
  }

  void _initWatch() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _streakBloc.add(
        WatchStreakEvent(userState.user.id, userState.user.entrepriseId ?? ""),
      );
    }
  }

  bool _hasNoSeason(StreakState state) =>
      state.streak.saisonNom == null || state.streak.saisonNom!.isEmpty;

  bool _canFlip(StreakState state) =>
      state is! StreakSeasonFinished && !_hasNoSeason(state);

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) return const SizedBox.shrink();

    return BlocProvider.value(
      value: _streakBloc,
      child: BlocConsumer<StreakBloc, StreakState>(
        listener: (context, state) {
          // si saison finie on retourne à la vue normale
          if (state is StreakSeasonFinished && isFlipped) {
            setState(() => isFlipped = false);
          }
          // Affichage de l'overlay de félicitations ou d'échec selon l'évolution du streak
          final current = state.streak.currentStreak;
          final lastSeen = state.streak.lastStreakSeen ?? 0;
          if (current == 0 && lastSeen == 0) return;
          // Si le streak a augmenté depuis la dernière fois, afficher l'overlay de félicitations
          if (current > lastSeen) {
            _showStreakOverlay(context, state, isWin: true);
            // sinon si le streak a été perdu (reset à 0 alors qu'il était > 0), afficher l'overlay de perte
          } else if (current < lastSeen) {
            _showStreakOverlay(context, state, isWin: false);
          }
        },
        builder: (blocContext, state) {
          if (state is StreakLoading) {
            return StreakLoadingWidget(theme: Theme.of(blocContext));
          }
          if (state is StreakError) {
            return StreakEmptyState(subtitle: state.message);
          }

          return GestureDetector(
            onTap: _canFlip(state)
                ? () => setState(() => isFlipped = !isFlipped)
                : null,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: isFlipped ? 3.14159 : 0),
              duration: 600.ms,
              curve: Curves.easeInOut,
              builder: (context, value, _) {
                final isFront = value < (3.14159 / 2);
                final theme = Theme.of(context);

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // si on est sur la face avant
                      isFront
                          ? AnimatedSwitcher(
                              // gerer la transition entre le streak normal et le streak saison fini
                              duration: 300.ms,
                              child: state is StreakSeasonFinished
                                  ? StreakFinishedView(
                                      key: const ValueKey('finished'),
                                      state: state,
                                    )
                                  : _buildFront(blocContext, state),
                            )
                          : _buildBack(blocContext),
                      if (isFront && state is! StreakSeasonFinished) ...[
                        _buildInfoButton(theme),
                        if (showInfo) _buildInfoOverlay(theme),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // face avant de la streak
  Widget _buildFront(BuildContext blocContext, StreakState state) {
    final theme = Theme.of(context);
    final int maxPhase = state.streakSteps?.isNotEmpty == true
        ? state.streakSteps!.last.to
        : 0;
    final bool isMaxLevel =
        state.streak.currentStreak >= maxPhase && maxPhase > 0;

    // seuil pour afficher la section de progression vers l'étape suivante (0 si on est au max)
    final threshold = isMaxLevel
        ? 0
        : (state.streakSteps
                  ?.firstWhere(
                    (e) => e.from == state.streak.currentStreak,
                    orElse: () => state.streakSteps!.last,
                  )
                  .requiredActionsQuotidiennes ??
              0);

    return StreakCardDecoration(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            StreakVisualHeader(state: state),
            const SizedBox(height: 16),
            if (isMaxLevel)
              const StreakMaxLevelBadge()
            else ...[
              _buildCountdownBadge(blocContext, state, theme),
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
    );
  }

  Widget _buildBack(BuildContext context) {
    final theme = Theme.of(context);
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: const StreakDetailsWidget(),
      ),
    );
  }

  Widget _buildCountdownBadge(
    BuildContext blocContext,
    StreakState state,
    ThemeData theme,
  ) {
    final lastUpdated = state.streak.lastUpdated;

    return CountdownBadge(
      // Si lastUpdated est null, on envoie null, ce qui affichera l'infini
      targetDate: lastUpdated?.add(const Duration(days: 14)),
      style: TextStyle(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
        // On augmente un peu la taille si c'est le symbole infini pour le style
        fontSize: lastUpdated == null ? 18 : 14,
      ),
      icon: Icon(LucideIcons.clock, size: 16, color: theme.colorScheme.primary),
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      prefix: '',
      onFinished: () {
        if (_isResetting || !mounted) return;
        _isResetting = true;

        final userState = blocContext.read<AppUserCubit>().state;
        if (userState is AppUserLoggedIn) {
          blocContext.read<StreakBloc>().add(
            WatchStreakEvent(
              userState.user.id,
              userState.user.entrepriseId ?? "",
            ),
          );
        }
      },
    );
  }

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

  void _showStreakOverlay(
    BuildContext context,
    StreakState state, {
    required bool isWin,
  }) {
    final streakBloc = context.read<StreakBloc>();
    final userCubit = context.read<AppUserCubit>();

    final streakDirectory = (state.streak.logoUrl != null)
        ? state.streak.logoUrl!.substring(
            0,
            state.streak.logoUrl!.lastIndexOf('/') + 1,
          )
        : "";

    final lastSeen = state.streak.lastStreakSeen ?? 0;
    final current = state.streak.currentStreak;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: isWin ? "Win" : "Loss",
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, anim1, anim2) {
        if (isWin) {
          return StreakCongratsPage(
            oldLogoUrl: "$streakDirectory$lastSeen.png",
            newLogoUrl: "$streakDirectory$current.png",
            onClose: () => _markAsSeen(streakBloc, userCubit, current),
          );
        } else {
          return StreakLossWidget(
            oldLogoUrl: "$streakDirectory$lastSeen.png",
            newLogoUrl: "$streakDirectory$current.png",
            onClose: () {
              _isResetting = false;
              _markAsSeen(streakBloc, userCubit, current);
            },
          );
        }
      },
    );
  }

  void _markAsSeen(StreakBloc bloc, AppUserCubit userCubit, int current) {
    final userState = userCubit.state;
    if (userState is AppUserLoggedIn) {
      bloc.add(MarkStreakAsSeenEvent(userState.user.id, current));
    }
  }
}
