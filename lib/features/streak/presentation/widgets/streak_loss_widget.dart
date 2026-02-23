import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';

class StreakLossWidget extends StatefulWidget {
  final String oldLogoUrl;
  final String newLogoUrl;
  final VoidCallback? onClose;

  const StreakLossWidget({
    super.key,
    required this.oldLogoUrl,
    required this.newLogoUrl,
    this.onClose,
  });

  @override
  State<StreakLossWidget> createState() => _StreakLossWidgetState();
}

class _StreakLossWidgetState extends State<StreakLossWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void handleClose() {
      widget.onClose?.call();
      if (context.canPop()) {
        context.pop();
      } else {
        widget.onClose?.call();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      body: GestureDetector(
        onTap: handleClose,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.transparent),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Oups, ta fleur a fané...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 28,
                      ),
                    ).animate().fadeIn().shake(hz: 3, curve: Curves.easeInOut),
                    const SizedBox(height: 10),
                    Text(
                      "Tu as perdu ta streak, mais ne baisse pas les bras !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(widget.oldLogoUrl, height: 160)
                              .animate()
                              .shake(duration: 1.seconds, hz: 2)
                              .scale(
                                duration: 1.5.seconds,
                                begin: const Offset(1, 1),
                                end: const Offset(1.2, 0.1),
                                curve: Curves.easeInQuart,
                              )
                              .tint(
                                color: Colors.black87,
                                duration: 1.2.seconds,
                              )
                              .fadeOut(delay: 800.ms, duration: 700.ms),
                          Image.network(widget.newLogoUrl, height: 100)
                              .animate()
                              .fadeIn(duration: 0.ms, begin: 0)
                              .fadeIn(delay: 1.2.seconds, duration: 800.ms)
                              .scale(
                                delay: 1.2.seconds,
                                duration: 1.seconds,
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1, 1),
                                curve: Curves.elasticOut,
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Bloc du bas synchronisé
                    Column(
                          children: [
                            Text(
                              "Tout n'est pas perdu.\nFais renaître ta fleur dès maintenant.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 40),
                            GradientButton(
                              label: "REPRENDRE LE DÉFI",
                              onPressed: handleClose,
                            ),
                          ],
                        )
                        .animate(delay: 2.seconds)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
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
