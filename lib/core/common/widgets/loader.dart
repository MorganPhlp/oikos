import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

// TODO: Voir si le loader est bien ou s'il faut l'améliorer

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Cercle de pulsation externe
              Transform.scale(
                scale: 1 + (_controller.value * 0.3),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gradientGreenStart.withValues(alpha: 0.3 * (1 - _controller.value)),
                        AppColors.gradientGreenEnd.withValues(alpha: 0.3 * (1 - _controller.value)),
                      ],
                    ),
                  ),
                ),
              ),
              // Cercle rotatif avec dégradé
              RotationTransition(
                turns: _controller,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientGreenStart,
                        AppColors.gradientGreenEnd,
                        AppColors.gradientGreenStart,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightBackground,
                      ),
                    ),
                  ),
                ),
              ),
              // Logo ou icône au centre (optionnel)
              const Icon(
                Icons.home_rounded,
                color: AppColors.gradientGreenStart,
                size: 32,
              ),
            ],
          );
        },
      ),
    );
  }
}
