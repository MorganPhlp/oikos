import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class SuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onLocalChange; // Typé en String pour plus de clarté
  final String? selectedSuggestion;

  const SuggestionsWidget({
    super.key,
    required this.suggestions,
    required this.onLocalChange,
    this.selectedSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center, // Centre les puces sur la ligne
      spacing: 8.0, // Espace horizontal entre deux puces
      runSpacing: 4.0, // Espace vertical entre deux lignes de puces
      children: suggestions.map((suggestion) {
        final bool isSelected = selectedSuggestion == suggestion;

        return ChoiceChip(
          // ChoiceChip est plus adapté pour une sélection que ActionChip
          label: Text(
            suggestion,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              onLocalChange(suggestion);
            }
          },
          selectedColor: AppColors.lightTextGreen.withOpacity(0.7),
          backgroundColor: AppColors.lightBackground,
          // Retire l'ombre ou les bordures par défaut si nécessaire
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
        );
      }).toList(),
    );
  }
}