import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakVisualHeader extends StatelessWidget {
  final StreakState state;
  const StreakVisualHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = state.streak.logoUrl?.toLowerCase();

    if (logoUrl == null || logoUrl.isEmpty) return const SizedBox(height: 160);

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            _buildParticle(theme.colorScheme.primary, (i - 1) * 30.0, -40),
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

  Widget _buildParticle(Color color, double offsetX, double offsetY) {
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
          duration: 2000.ms,
        )
        .fadeOut();
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
}
