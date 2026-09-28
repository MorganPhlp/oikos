import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_caroussel_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_statistics_widget.dart';

// Widget affichant les détails du streak, avec un carrousel des étapes et des statistiques
class StreakDetailsWidget extends StatelessWidget {
  final void Function()? onSaisonFinished;
  const StreakDetailsWidget({super.key, this.onSaisonFinished});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              StreakCarousselWidget().animate(
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 800)),
                ],
              ),
              const SizedBox(height: 16),
              DecorativeSeparator(),
              const SizedBox(height: 16),
              StreakStatisticsWidget().animate(
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 800)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
