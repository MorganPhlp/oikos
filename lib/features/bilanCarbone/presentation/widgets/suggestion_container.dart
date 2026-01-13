import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class SuggestionContainer extends StatelessWidget { 
  const SuggestionContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gradientGreenEnd.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gradientGreenEnd.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Vous pouvez répondre à l\'aide des suggestions ou bien entrer sélectionner des valeurs personnalisées.',
              style: TextStyle(
                color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}