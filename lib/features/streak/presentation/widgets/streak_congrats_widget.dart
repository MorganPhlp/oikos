import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';

class StreakCongratsPage extends StatefulWidget {
  final String oldLogoUrl;
  final String newLogoUrl;
  final VoidCallback? onClose;

  const StreakCongratsPage({
    super.key,
    required this.oldLogoUrl,
    required this.newLogoUrl,
    this.onClose,
  });

  @override
  State<StreakCongratsPage> createState() => _StreakCongratsPageState();
}

class _StreakCongratsPageState extends State<StreakCongratsPage> {
  @override
  void initState() {
    super.initState();
    _handleConfetti();
  }

  void _handleConfetti() {
    // On attend l'impact (800ms de délai + 350ms de chute)
    Future.delayed(1150.ms, () {
      if (mounted) {
        final theme = Theme.of(context);
        Confetti.launch(
          context,
          options: ConfettiOptions(
            particleCount: 100,
            spread: 80,
            y: 0.5,
            x: 0.5,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary,
              theme.colorScheme.secondary,
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: GestureDetector(
        onTap: () => {widget.onClose?.call(), context.pop()},
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const SizedBox.expand(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "C'est qui le champion ?!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.tertiary,
                        fontSize: 32,
                      ),
                    ).animate().fadeIn().scale(curve: Curves.elasticOut),
                    const SizedBox(height: 10),
                    Text(
                      "TA FLEUR A ÉVOLUÉ !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.9,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(widget.oldLogoUrl, height: 150)
                              .animate()
                              .scale(
                                delay: 800.ms,
                                begin: const Offset(1.0, 1.0),
                                end: const Offset(1.7, 0.1),
                                duration: 200.ms,
                                curve: Curves.easeInQuad,
                              )
                              .fadeOut(duration: 100.ms),
                          Image.network(widget.newLogoUrl, height: 240)
                              .animate()
                              .fadeIn(duration: 0.ms, begin: 0)
                              .slideY(
                                delay: 800.ms,
                                begin: -2.5,
                                end: 0,
                                duration: 350.ms,
                                curve: Curves.easeInExpo,
                              )
                              .fadeIn(delay: 800.ms, duration: 50.ms)
                              .then()
                              .shake(hz: 4, duration: 400.ms)
                              .shimmer(duration: 1.5.seconds),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GradientButton(
                      label: "VOIR MA FLEUR",
                      onPressed: () => {widget.onClose?.call(), context.pop()},
                      isTertiary: true,
                    ).animate(delay: 2.2.seconds).fadeIn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
