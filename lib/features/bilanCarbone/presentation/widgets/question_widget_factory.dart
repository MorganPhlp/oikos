import 'package:flutter/material.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart'; // Ton Enum
import 'package:oikos/features/bilanCarbone/presentation/widgets/counter_item.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/multi_selection.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/number_input.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_number_wrapper.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/selection_button.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/slider.dart';

class QuestionWidgetFactory extends StatelessWidget {
  final QuestionBilanEntity question;
  final dynamic currentValue; // La valeur actuelle (String, double ou Map)
  final Function(dynamic) onLocalChange; // Callback quand l'utilisateur touche l'UI
  final Function(bool) onValidityChange; // Callback pour remonter la validité

  const QuestionWidgetFactory({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onLocalChange,
    required this.onValidityChange,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.typeWidget) {

      // =========================================================
      // CAS 1 : CHOIX UNIQUE (Radio)
      // =========================================================
      case TypeWidget.choixUnique:
      case TypeWidget.booleen:
        return Column(
          children: question.options.map((option) {
            return OikosSelectionButton(
              label: option,
              isSelected: currentValue == option,
              onTap: () => onLocalChange(option),
            );
          }).toList(),
        );

      // =========================================================
      // CAS 2 : CHOIX MULTIPLE (Mosaïque) - NOUVEAU !
      // =========================================================
      case TypeWidget.choixMultiple:
        // On s'assure que currentValue est bien une List<String>
        // Sinon, on initialise une liste vide []
        final List<String> selection = (currentValue is List) 
            ? List<String>.from(currentValue as List) 
            : [];

        return OikosMultiSelection(
          options: question.options,
          selectedValues: selection,
          onChanged: (newList) => onLocalChange(newList),
        );

      // =========================================================
      // CAS 3 : NOMBRE (Input Texte)
      // =========================================================
      case TypeWidget.nombre:
      final int val = (currentValue is num) 
          ? (currentValue as num).toInt() 
          : 0;

      return QuestionNumberWrapper(
        key: ValueKey(question.slug),
        question: question,
        initialValue: val,
        onValidSubmit: (newValue) => onLocalChange(newValue),
        onValidityChange: (isValid) => onValidityChange(isValid),
      );


      // =========================================================
      // CAS 4 : SLIDER
      // =========================================================
      case TypeWidget.slider:
        final double val = (currentValue is num) 
            ? (currentValue as num).toDouble() 
            : (question.min ?? 0.0);

        return OikosSlider(
          value: val,
          min: question.min ?? 0.0,
          max: question.max ?? 100.0,
          unit: question.unit ?? '',
          onChanged: (newValue) => onLocalChange(newValue),
        );

      // =========================================================
      // CAS 5 : COMPTEUR 
      // =========================================================
      case TypeWidget.compteur:

        // On s'assure que la valeur actuelle est un Map<String, int>
        // Si ce n'est pas le cas, on initialise à une Map vide.
        final Map<String, dynamic> currentCounts = (currentValue is Map)
            ? Map<String, dynamic>.from(currentValue as Map)
            : {};

        // On utilise une ListView pour afficher tous les compteurs
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: question.options.map((optionSlug) {
            // 1. Extraction de la valeur actuelle pour cet item (par défaut 0)
            final int count = (currentCounts[optionSlug] is num)
                ? (currentCounts[optionSlug] as num).toInt()
                : 0;

            // 2. Fonction de mise à jour pour cet item
            void updateCount(int newCount) {
              // Créer une nouvelle map pour ne pas modifier l'état directement
              final Map<String, dynamic> newSituation =
                  Map<String, dynamic>.from(currentCounts);

              newSituation[optionSlug] = newCount;

              // Remonter la nouvelle map complète au Cubit/StatefulWidget parent
              onLocalChange(newSituation);
            }

            // 3. Rendu du widget CounterItem
            return CounterItem(
              label: optionSlug, // On nettoie le slug pour l'affichage
              value: count,
              onIncrement: () => updateCount(count + 1),
              onDecrement: () => updateCount(count > 0 ? count - 1 : 0),
            );
          }).toList(),
        );

      // ... (Code du compteur et default) ...
      default:
         return Text("Widget non supporté : ${question.typeWidget}");
    }
  }
}