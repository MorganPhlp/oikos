import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class SuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onLocalChange; 
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
          label: Text(
            suggestion,
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              onLocalChange(suggestion);
            }
          },
          selectedColor: AppColors.lightTextGreen.withOpacity(0.7),
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? Colors.transparent : Theme.of(context).colorScheme.outline,
            ),
          ),
        );
      }).toList(),
    );
  }
}