import 'package:freezed_annotation/freezed_annotation.dart';
import 'type_widget.dart';

part 'question_entity.freezed.dart';
part 'question_entity.g.dart';

@freezed
sealed class QuestionBilanEntity with _$QuestionBilanEntity {
  // Constructeur privé pour permettre l'ajout de méthodes/getters
  const QuestionBilanEntity._();

  const factory QuestionBilanEntity({
    @Default(0) int id,
    
    // C'est ce que Publicodes utilise pour identifier la variable.
    @Default('') String slug,

    @Default('') String question,

    // Mapping vers la colonne SQL
    // Vérifiez si votre colonne s'appelle "categorieEmpreinte" ou "categorieempreinte"
    @JsonKey(name: 'categorie_empreinte') 
    @Default('') String categorieEmpreinte,

    // L'icône (emoji ou chemin)
    @Default('') String? icone,

    // Utilisation de l'Enum pour la sécurité
    // unknownEnumValue: évite le crash si la DB a une valeur inconnue
    @JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre)
    @Default(TypeWidget.nombre) TypeWidget typeWidget,

    @JsonKey(name: 'config_json') 
    @Default({}) Map<String, dynamic> config,
    
    @JsonKey(name: 'ordre_affichage')
    @Default(0) int ordre,

  }) = _QuestionBilanEntity;

  factory QuestionBilanEntity.fromJson(Map<String, dynamic> json) =>
      _$QuestionBilanEntityFromJson(json);

  // Récupère la liste des choix possibles (ex: ["maison", "appartement"])
List<Map<String, dynamic>> get options {
  final list = config['options'];
  
  if (list is List) {
    return list.map((e) {
        final Map<String, dynamic> element = {};
        element['label'] = e.toString().toLowerCase().split('.').first;
        element['value'] = e.toString();
        return element;

    }).toList();
  }
  return [];
}

  // Récupère l'unité (ex: "km", "m2", "kg")
  String? get unit => config['unit'] as String?;

  // Pour les sliders et inputs numériques
  double? get min => (config['min'] as num?)?.toDouble();
  double? get max => (config['max'] as num?)?.toDouble();
  
  // Valeur par défaut suggérée par l'ADEME
  dynamic get defaultValue => config['defaultValue'];
  
  // Description / Aide contextuelle
  String? get description => config['description'] as String?;
}