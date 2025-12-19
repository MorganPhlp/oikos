import 'package:flutter/material.dart';
import 'selection_button.dart';

class OikosMultiSelection extends StatelessWidget {
  // Changement du type ici : List<dynamic> car ce sont des Maps
  final List<dynamic> options; 
  final List<String> selectedValues;
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
        // Extraction des valeurs depuis la Map
        final String label = option['label'];
        final String technicalValue = option['value'];
        
        // La vérification se fait sur la valeur technique (le slug complet)
        final isSelected = selectedValues.contains(technicalValue);

        return OikosSelectionButton(
          label: label, // Affichage : "Maison"
          isSelected: isSelected,
          onTap: () {
            // Logique d'ajout / retrait basée sur la valeur technique
            final newList = List<String>.from(selectedValues);
            if (isSelected) {
              newList.remove(technicalValue);
            } else {
              newList.add(technicalValue);
            }
            onChanged(newList);
          },
        );
      }).toList(),
    );
  }
}