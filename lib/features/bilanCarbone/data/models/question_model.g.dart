// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionBilanModel _$QuestionBilanModelFromJson(Map<String, dynamic> json) =>
    _QuestionBilanModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      question: json['question'] as String? ?? '',
      categorieEmpreinte: json['categorie_empreinte'] as String? ?? '',
      icone: json['icone'] as String? ?? '',
      typeWidget:
          $enumDecodeNullable(
            _$TypeWidgetEnumMap,
            json['type_widget'],
            unknownValue: TypeWidget.nombre,
          ) ??
          TypeWidget.nombre,
      config: json['config_json'] as Map<String, dynamic>? ?? const {},
      ordre: (json['ordre_affichage'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$QuestionBilanModelToJson(_QuestionBilanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'question': instance.question,
      'categorie_empreinte': instance.categorieEmpreinte,
      'icone': instance.icone,
      'type_widget': _$TypeWidgetEnumMap[instance.typeWidget]!,
      'config_json': instance.config,
      'ordre_affichage': instance.ordre,
    };

const _$TypeWidgetEnumMap = {
  TypeWidget.slider: 'SLIDER',
  TypeWidget.nombre: 'NOMBRE',
  TypeWidget.choixUnique: 'CHOIX_UNIQUE',
  TypeWidget.choixMultiple: 'CHOIX_MULTIPLE',
  TypeWidget.booleen: 'BOOLEEN',
  TypeWidget.compteur: 'COMPTEUR',
};
