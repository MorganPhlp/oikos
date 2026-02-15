import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Tes imports à adapter
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/features/streak/presentation/widgets/countdown_badge.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_details_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_empty_state.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_loading.dart';
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

  bool _isSeasonFinished(StreakState state) =>
      state.streak.saisonFin?.isBefore(DateTime.now()) ?? false;

  bool _hasNoSeason(StreakState state) =>
      state.streak.saisonNom == null || state.streak.saisonNom!.isEmpty;

  bool _canFlip(StreakState state) =>
      !_isSeasonFinished(state) && !_hasNoSeason(state);

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
                    ..setEntry(3, 2, 0.001)
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

  // --- Vues principales ---

  Widget _buildFront(BuildContext context, StreakState state) {
    final theme = Theme.of(context);
    final bool isFinished = _isSeasonFinished(state);
    final bool noSeason = _hasNoSeason(state);

    if (isFinished) return _buildSeasonFinishedView(context, state);

    final threshold = noSeason
        ? 0
        : (state.streakSteps
                  ?.firstWhere(
                    (e) => e.from == state.streak.currentStreak,
                    orElse: () => state.streakSteps!.first,
                  )
                  .requiredActionsQuotidiennes ??
              0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _StreakCardDecoration(
          theme: theme,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildVisualHeader(state, theme),
                const SizedBox(height: 16),
                noSeason
                    ? _buildNoSeasonBadge(theme)
                    : _buildCountdownBadge(state, theme),
                const SizedBox(height: 20),
                const DecorativeSeparator(),
                const SizedBox(height: 20),
                _buildInstructionText(noSeason, theme),
                const SizedBox(height: 20),
                Opacity(
                  opacity: noSeason ? 0.5 : 1.0,
                  child: _buildProgressSection(
                    context,
                    state,
                    threshold,
                    theme,
                  ),
                ),
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

  Widget _buildVisualHeader(StreakState state, ThemeData theme) {
    final logoUrl = state.streak.logoUrl?.toLowerCase();
    if (logoUrl == null || logoUrl.isEmpty) return const SizedBox(height: 160);

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            _buildParticle(
              theme.colorScheme.primary,
              (i - 1) * 30.0,
              -40,
              2000.ms,
            ),
          Animate(
            key: ValueKey(
              '${logoUrl}_${state is StreakUpdated ? (state as StreakUpdated).evolution : 'idle'}',
            ),
            effects: _buildEffects(state),
            child: Image.network(logoUrl, height: 140, fit: BoxFit.contain)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: -10,
                  duration: 2.seconds,
                  curve: Curves.easeInOutSine,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    StreakState state,
    int threshold,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildProgressBarBlock(
              context,
              icon: LucideIcons.userCheck,
              current: state.actionsQuotidiennes ?? 0,
              total: threshold == 0 ? 1 : threshold,
              label: "Individuel",
            ),
          ),
          Container(
            height: 70,
            width: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildProgressBarBlock(
              context,
              icon: LucideIcons.users,
              current: (state.hasCompletedActionCommunautaire ?? false) ? 1 : 0,
              total: 1,
              label: "Collectif",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarBlock(
    BuildContext context, {
    required IconData icon,
    required int current,
    required int total,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            Text(
              "$current/$total",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildGradientProgressBar(current, total, theme),
        const SizedBox(height: 12),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // --- Méthodes d'animation et de dessin ---

  Widget _buildParticle(
    Color color,
    double offsetX,
    double offsetY,
    Duration duration,
  ) {
    return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .move(
          begin: Offset(offsetX, offsetY),
          end: Offset(offsetX + 20, offsetY - 80),
          duration: duration,
          curve: Curves.easeOutQuad,
        )
        .fadeOut(duration: duration);
  }

  Widget _buildGradientProgressBar(int current, int total, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: ShaderMask(
        shaderCallback: (Rect bounds) => LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
            theme.colorScheme.error,
          ],
        ).createShader(bounds),
        child: LinearProgressIndicator(
          value: (current / total).clamp(0.0, 1.0),
          minHeight: 4,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
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
          begin: const Offset(1, 1),
          end: const Offset(0.7, 0.7),
        ),
      ];
    }
    return [
      ScaleEffect(
        duration: 900.ms,
        curve: Curves.elasticOut,
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
      ),
      FadeEffect(duration: 400.ms),
    ];
  }

  // --- Méthodes UI Additionnelles ---
  Widget _buildInstructionText(bool noSeason, ThemeData theme) => Text(
    (noSeason
            ? "En attente d'une nouvelle saison"
            : "pour réaliser ton action quotidienne et collective")
        .toUpperCase(),
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 2.0,
      color: theme.colorScheme.primary.withValues(alpha: 0.9),
    ),
  );
  Widget _buildNoSeasonBadge(ThemeData theme) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.calendarOff,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        const Text(
          "Aucune saison active",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
  Widget _buildCountdownBadge(
    StreakState state,
    ThemeData theme,
  ) => CountdownBadge(
    targetDate: state.streak.lastUpdated.add(const Duration(days: 14)),
    prefix: "",
    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
    icon: Icon(LucideIcons.clock, size: 16, color: theme.colorScheme.primary),
    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
    borderColor: theme.colorScheme.primary.withValues(alpha: 0.2),
    onFinished: () {},
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
  Widget _buildSeasonFinishedView(BuildContext context, StreakState state) {
    /* Code de la vue terminée identique au précédent */
    return Container();
  }
}

// --- Composant externe ---
class _StreakCardDecoration extends StatelessWidget {
  final Widget child;
  final ThemeData theme;
  const _StreakCardDecoration({required this.child, required this.theme});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary.withValues(alpha: 0.55),
          theme.colorScheme.primary.withValues(alpha: 0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
      ),
    ),
    child: child,
  );
}
