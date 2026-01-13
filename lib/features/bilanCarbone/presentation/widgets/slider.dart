

import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class OikosSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String unit;
  final ValueChanged<double> onChanged;

  const OikosSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Valeur affichée en gros (ex: "50 m²")
        Text(
          "${value.round()} $unit",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.gradientGreenEnd, 
          ),
        ),
        
        const SizedBox(height: 20),

        // 2. Le Slider customisé
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.gradientGreenEnd,
            inactiveTrackColor: AppColors.gradientGreenEnd.withOpacity(0.2),
            thumbColor: AppColors.gradientGreenEnd,
            overlayColor: AppColors.gradientGreenEnd.withOpacity(0.1),
            trackHeight: 8.0, // Épaisseur de la barre
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions ?? (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),

        const SizedBox(height: 10),

        // 3. Encadré de valeur (Input simulé)
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "${value.round()}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}