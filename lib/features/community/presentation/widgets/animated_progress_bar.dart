import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress; // Valeur entre 0.0 et 1.0
  final Color color;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Fond de la barre (Rail)
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Partie animée — begin = end pour éviter de rejouer l'anim au rebuild
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: progress.clamp(0.0, 1.0),
                end: progress.clamp(0.0, 1.0),
              ),
              duration: duration,
              curve:
                  Curves.easeOutCubic, // Animation fluide qui ralentit à la fin
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      // Petit éclat sur la barre qui progresse
                      boxShadow: [
                        if (value > 0.05)
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Marqueur de seuil à 60% (Threshold)
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.only(left: constraints.maxWidth * 0.6),
                  child: Container(
                    height: 12,
                    width: 2,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
