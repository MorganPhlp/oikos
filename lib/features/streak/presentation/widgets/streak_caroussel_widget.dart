import 'dart:ui'; // Obligatoire pour ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

// Widget de carrousel pour afficher les différentes étapes du streak
class StreakCarousselWidget extends StatefulWidget {
  const StreakCarousselWidget({super.key});

  @override
  State<StreakCarousselWidget> createState() => _StreakCarousselWidgetState();
}

class _StreakCarousselWidgetState extends State<StreakCarousselWidget> {
  late CarouselController controller;

  @override
  void initState() {
    super.initState();
    final streak = context.read<StreakBloc>().state.streak;
    controller = CarouselController(initialItem: streak.currentStreak);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        final streak = state.streak;
        final String? logoUrl = streak.logoUrl;

        final String streakDirectory =
            (logoUrl != null && logoUrl.contains('/'))
            ? logoUrl.substring(0, logoUrl.lastIndexOf('/') + 1)
            : "";

        return SizedBox(
          height: 200,
          child: CarouselView.weightedBuilder(
            flexWeights: [2, 4, 2],
            controller: controller,
            scrollDirection: Axis.horizontal,
            backgroundColor: Colors.transparent,
            itemSnapping: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              final bool isCurrentEvolution = index == streak.currentStreak;
              final bool isAchieved = index < streak.currentStreak;
              final bool isFuture = index > streak.currentStreak;
              return Center(
                child: Opacity(
                  opacity: isCurrentEvolution ? 1.0 : (isAchieved ? 0.8 : 0.4),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageFiltered(
                        imageFilter: isFuture
                            ? ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0)
                            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Image.network(
                          "$streakDirectory$index.png",
                          fit: BoxFit.contain,
                          errorBuilder: (context, _, __) => const Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      if (isAchieved)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: theme.colorScheme.onPrimary,
                              size: 16,
                            ),
                          ),
                        ),
                      if (isFuture)
                        const Icon(Icons.lock, color: Colors.white70, size: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
