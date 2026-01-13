import 'dart:collection';
import 'package:oikos/core/common/util.dart';

import 'type_widget.dart';
class QuestionBilanEntity {
  final int id;
  final String slug;
  final String question;
  final String categorieEmpreinte;
  final String? icone;
  final TypeWidget typeWidget;
  final Map<String, dynamic> config;
  final int ordre;

  const QuestionBilanEntity({
    required this.id,
    required this.slug,
    required this.question,
    required this.categorieEmpreinte,
    this.icone,
    required this.typeWidget,
    required this.config,
    required this.ordre,
  });

  // Récupère la liste des choix possibles (ex: ["maison", "appartement"]) et renvoie une liste de maps {'label':..., 'value':...} ou le label est une version lisible et le value est la valeur slug
List<Map<String, dynamic>> get options {
  final list = config['options'];
  
  if (list is List) {
    return list.map((e) {
        final Map<String, dynamic> element = {};
        if (e.contains('présent')){
          var parts = e.toString().toLowerCase().split('.');
          if (parts.length >= 2) {
            element['label'] = parts[parts.length - 2];
          }
        }
        else{
          element['label'] = e.toString().toLowerCase().split('.').first;
        }
        element['label'] = element['label'].toString().capitalize();
        element['value'] = e.toString();
        return element;

    }).toList();
  }
  return [];
}

  // Récupère l'unité (ex: "km", "m2", "kg")
  String? get unit => config['unit'] as String?;

  // Pour les sliders, inputs numeriques et compteurs
  double? get min => (config['min'] as num?)?.toDouble();
  double? get max => (config['max'] as num?)?.toDouble();
  
  // Valeur par défaut suggérée par l'ADEME
  dynamic get defaultValue => config['defaultValue'];
  
  // Description / Aide contextuelle
  String? get description => config['description'] as String?;

  // Suggestions de réponses rapides
  HashMap<String, dynamic>? get suggestions {
  final sugg = config['suggestions'];
  if (sugg is Map) {
    return HashMap<String, dynamic>.from(sugg);
  }
  return null;
}

  /// Retourne la valeur par défaut à utiliser pour l'initialisation de la réponse
  /// en fonction du type de widget
  dynamic getInitialValue() {
    switch (typeWidget) {
      case TypeWidget.slider:
        return min ?? 0.0;
      case TypeWidget.compteur:
        return <String, int>{};
      default:
        return null;
    }
  }

  /// Indique si le type de widget nécessite une validation
  /// (slider et compteur sont toujours valides par défaut)
  bool isAlwaysValid() {
    return typeWidget == TypeWidget.slider || typeWidget == TypeWidget.compteur;
  }
}