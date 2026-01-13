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

  // Récupère la liste des choix possibles (ex: ["maison", "appartement"])
  List<Map<String, dynamic>> get options {
    final list = config['options'];

    if (list is List) {
      return list.map((e) {
        // Si e est déjà un Map (JSON object avec label/value)
        if (e is Map<String, dynamic>) {
          return Map<String, dynamic>.from(e);
        }

        // Si e est une String (ancien format)
        final Map<String, dynamic> element = {};
        final String stringValue = e.toString();

        if (stringValue.contains('présent')){
          var parts = stringValue.toLowerCase().split('.');
          if (parts.length >= 2) {
            element['label'] = parts[parts.length - 2];
          }
        }
        else{
          element['label'] = stringValue.toLowerCase().split('.').first;
        }
        element['value'] = stringValue;
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
  List<Map<String, dynamic>>? get suggestions {
    final sugg = config['suggestions'];
    if (sugg is List) {
      return List<Map<String, dynamic>>.from(
        sugg.map((e) => Map<String, dynamic>.from(e as Map))
      );
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