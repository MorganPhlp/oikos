import 'dart:convert';

import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';

Map<String, dynamic> formaterPourSimulation(
  QuestionBilanEntity question,
  dynamic valeur,
) {
  final Map<String, dynamic> situation = {};
  final String parentSlug = question.slug;
  if (valeur == null) return situation;
  // On s'assure d'avoir une String pour les tests de format JSON
  final String rawValue = valeur.toString();
  // --- CAS 1 : CHOIX MULTIPLE (Liste JSON) ---
  // Transforme ["élec", "gaz"] en {"chauffage . élec": "'oui'", ...}
  if (question.typeWidget == TypeWidget.choixMultiple ||
      rawValue.startsWith('[')) {
    try {
      final List<dynamic> values = (valeur is String)
          ? jsonDecode(rawValue)
          : valeur;
      for (var v in values) {
        if (v != null) {
          situation['$parentSlug . $v'] = "'oui'";
        }
      }
      return situation;
    } catch (e) {
      throw FormatException(
          'Valeur pour choix multiple doit être une liste ou un JSON de liste');
    }
  }
  // --- CAS 2 : COMPTEUR (Map JSON) ---
  // Transforme {"smartphone": 2} en {"numérique . smartphone": 2}
  if (question.typeWidget == TypeWidget.compteur || rawValue.startsWith('{')) {
    try {
      final Map<String, dynamic> counts = (valeur is String)
          ? jsonDecode(rawValue)
          : valeur;
      counts.forEach((key, val) {
        if (val != null) {
          situation['$parentSlug . $key'] = val;
        }
      });
      return situation;
    } catch (e) {
      throw FormatException(
          'Valeur pour compteur doit être une map ou un JSON de map');
    }
  }
  // --- CAS 3 : VALEURS CLASSIQUES (Nombre ou Texte) ---
  final numericValue = double.tryParse(rawValue);
  if (numericValue != null) {
    situation[parentSlug] = numericValue;
  } else if (rawValue.isNotEmpty) {
    // Ajout des simples quotes pour les catégories Publicodes
    situation[parentSlug] = "'$rawValue'";
  }
  return situation;
}
