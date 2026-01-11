import 'package:flutter/material.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/counter_item.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/multi_selection.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_number_wrapper.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/selection_button.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/slider.dart';

class QuestionWidgetFactory extends StatelessWidget {
  final QuestionBilanEntity question;
  final dynamic currentValue;
  final Function(dynamic) onLocalChange;
  final Function(bool) onValidityChange;

  const QuestionWidgetFactory({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onLocalChange,
    required this.onValidityChange,
  });

  @override
  Widget build(BuildContext context) {
    // On récupère les options déjà transformées par ton getter complexe
    final List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(question.options);

    switch (question.typeWidget) {
      // =========================================================
      // CAS 1 : CHOIX UNIQUE (Radio) & BOOLEEN
      // =========================================================
      case TypeWidget.choixUnique:
      case TypeWidget.booleen:
        return Column(
          children: options.map((option) {
            return OikosSelectionButton(
              label: option['label'] as String,
              isSelected: currentValue == option['value'],
              onTap: () {
                // 1. On met à jour la valeur
                onLocalChange(option['value']);
                // 2. on debloque le boutton
                onValidityChange(true);
              },
            );
          }).toList(),
        );

      // =========================================================
      // CAS 2 : CHOIX MULTIPLE
      // =========================================================
      case TypeWidget.choixMultiple:
        final List<String> selection = (currentValue is List)
            ? List<String>.from(currentValue)
            : [];

        return OikosMultiSelection(
          options: options, // On passe la liste de Maps
          selectedValues: selection,
          onChanged: (newList) => {
            onLocalChange(newList),
            onValidityChange(true),
          },
        );

      // =========================================================
      // CAS 3 : NOMBRE (Input Texte)
      // =========================================================
      case TypeWidget.nombre:
        final int val = (currentValue is num) ? (currentValue as num).toInt() : 0;

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
        final Map<String, dynamic> currentCounts = (currentValue is Map)
            ? Map<String, dynamic>.from(currentValue)
            : {};
        
        //verifier si on a atteint la limite de reponses
        final int totalCount = currentCounts.values.fold<int>(0, (sum, item) {
          if (item is num) {
            return sum + (item as num).toInt();
          }
          return sum;
        });

        bool isMaxReached() {
          if (question.max != null && totalCount >= question.max!) {
            return true;
          }
          return false;
        }

        return Column(
          children: options.map((option) {
            final String technicalKey = option['value'] as String;
            final String displayName = option['label'] as String;

            final int count = (currentCounts[technicalKey] is num)
                ? (currentCounts[technicalKey] as num).toInt()
                : 0;

            return CounterItem(
              label: displayName,
              value: count,
              isMaxReached: isMaxReached(),
              onIncrement: () {
                final newSituation = Map<String, dynamic>.from(currentCounts);
                newSituation[technicalKey] = count + 1;
                onLocalChange(newSituation);
              },
              onDecrement: () {
                if (count > 0) {
                  final newSituation = Map<String, dynamic>.from(currentCounts);
                  newSituation[technicalKey] = count - 1;
                  onLocalChange(newSituation);
                }
              },
            );
          }).toList(),
        );

      default:
        return Text("Widget non supporté : ${question.typeWidget}");
    }
  }
}