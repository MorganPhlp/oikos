import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/promotion_cubit.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/promotion_state.dart';

class PromoteToHabitudeOverlay extends StatefulWidget {
  const PromoteToHabitudeOverlay({super.key});

  @override
  State<PromoteToHabitudeOverlay> createState() =>
      _PromoteToHabitudeOverlayState();
}

class _PromoteToHabitudeOverlayState extends State<PromoteToHabitudeOverlay> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<PromoteActionsCubit, PrommotionState>(
      listenWhen: (prev, curr) => curr.isDone,
      listener: (context, state) => Navigator.of(context).pop(),
      child: BlocBuilder<PromoteActionsCubit, PrommotionState>(
        builder: (context, state) {
          if (state.isDone) return const SizedBox.shrink();

          final remainingActions = state.actions.sublist(state.currentIndex);

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      color: colorScheme.scrim.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        _buildHeader(theme),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              SizedBox(
                                height: 520,
                                child: CardSwiper(
                                  controller: _controller,
                                  cardsCount: remainingActions.length,
                                  numberOfCardsDisplayed:
                                      remainingActions.length > 1 ? 2 : 1,
                                  backCardOffset: const Offset(0, 30),
                                  scale: 0.9,
                                  padding: const EdgeInsets.only(bottom: 45),
                                  maxAngle: 25,
                                  threshold: 80,
                                  onSwipe: (prev, curr, direction) {
                                    if (direction ==
                                        CardSwiperDirection.right) {
                                      context
                                          .read<PromoteActionsCubit>()
                                          .promoteCurrentAction();
                                    } else {
                                      context
                                          .read<PromoteActionsCubit>()
                                          .discardCurrentAction();
                                    }
                                    return true;
                                  },
                                  cardBuilder: (context, index, x, y) {
                                    final action =
                                        remainingActions[index].action;
                                    final actionTheme = theme
                                        .extension<ActionCardTheme>()!;
                                    final categoryColor = actionTheme
                                        .getCategoryColor(action.categoryName);
                                    return _buildMainCard(
                                      context,
                                      action,
                                      categoryColor,
                                      actionTheme,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: _buildActionButtons(
                                  context,
                                  colorScheme,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.partyPopper,
              color: theme.colorScheme.onPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Bravo pour ton assiduité !",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Et si on transformait ces actions en véritables habitudes ?",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    BuildContext context,
    dynamic action,
    Color categoryColor,
    ActionCardTheme actionTheme,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 125,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor,
                      categoryColor.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      top: -10,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: Icon(
                          action.icon,
                          size: 130,
                          color: colorScheme.onPrimary.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        action.icon,
                        color: colorScheme.onPrimary,
                        size: 55,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        action.categoryName.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      action.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      action.description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildStatRow(action, colorScheme),
                    const SizedBox(height: 25),
                    DecorativeSeparator(),
                    const SizedBox(height: 12),
                    _footer(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(dynamic action, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _cardStat(
          LucideIcons.zap,
          "${action.impactScore} pts",
          colorScheme.primary,
        ),
        _cardStat(LucideIcons.gauge, action.difficulty, colorScheme.secondary),
        _cardStat(LucideIcons.calendar, action.frequency, colorScheme.tertiary),
      ],
    );
  }

  Widget _cardStat(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _roundButton(
          LucideIcons.x,
          colorScheme.tertiary,
          colorScheme.onError,
          () => _controller.swipe(CardSwiperDirection.left),
        ),
        const SizedBox(width: 35),
        _roundButton(
          LucideIcons.check,
          colorScheme.primary,
          colorScheme.onPrimary,
          () => _controller.swipe(CardSwiperDirection.right),
          isLarge: true,
        ),
      ],
    );
  }

  Widget _roundButton(
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap, {
    bool isLarge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isLarge ? 72 : 62,
        width: isLarge ? 72 : 62,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: isLarge ? 32 : 26),
      ),
    );
  }

  Widget _footer(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.sparkles, size: 14, color: colorScheme.primary),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              "Swipe à droite pour m'adopter !",
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
