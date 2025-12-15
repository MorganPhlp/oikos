import 'package:flutter/material.dart';
import 'selection_button.dart'; // Importe ton bouton de base

class OikosMultiSelection extends StatelessWidget {
  final List<String> options;
  final List<String> selectedValues; // Une liste, car on peut en choisir plusieurs
  final ValueChanged<List<String>> onChanged;

  const OikosMultiSelection({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);

        return OikosSelectionButton(
          label: option,
          isSelected: isSelected,
          onTap: () {
            // Logique d'ajout / retrait
            final newList = List<String>.from(selectedValues);
            if (isSelected) {
              newList.remove(option);
            } else {
              newList.add(option);
            }
            onChanged(newList);
          },
        );
      }).toList(),
    );
  }
}