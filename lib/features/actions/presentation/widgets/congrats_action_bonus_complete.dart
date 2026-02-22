import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions/domain/entities/user_active_action_entity.dart';
import 'package:oikos/features/actions/presentation/widgets/animated_progress_bar.dart';

class CongratsActionBonusComplete extends StatefulWidget {
  final UserActiveActionEntity activeAction;

  const CongratsActionBonusComplete({super.key, required this.activeAction});

  @override
  State<CongratsActionBonusComplete> createState() =>
      _CongratsActionBonusCompleteState();
}

class _CongratsActionBonusCompleteState
    extends State<CongratsActionBonusComplete>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _contentOpacity;

  bool _startProgress = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _startProgress = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackground(context),
          ScaleTransition(
            scale: _scaleAnimation,
            child: _buildMainFrame(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(color: colorScheme.scrim.withValues(alpha: 0.7)),
      ),
    );
  }

  Widget _buildMainFrame(BuildContext context) {
    final theme = Theme.of(context);
    final actionColorScheme = Theme.of(context).extension<ActionCardTheme>()!;
    final colorAction = actionColorScheme.getCategoryColor(
      widget.activeAction.action.categoryName,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _contentOpacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.activeAction.action.icon, size: 80, color: colorAction),
            const SizedBox(height: 8),
            Text(
              widget.activeAction.action.categoryName.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(color: colorAction),
            ),
            Text(
              widget.activeAction.action.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedProgressBar(
              activeAction: widget.activeAction,
              start: _startProgress,
              onComplete: _onProgressComplete,
            ),
            const SizedBox(height: 12),
            Text(
              'Félicitations ! Ton impact score a été mis à jour.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: actionColorScheme.getCategoryColor(
                  widget.activeAction.action.categoryName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onProgressComplete() {
    if (widget.activeAction.streakCount >= widget.activeAction.maxCount) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    }

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
