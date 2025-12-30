import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/type_widget.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
sealed class QuestionBilanModel with _$QuestionBilanModel {
  const QuestionBilanModel._();

  const factory QuestionBilanModel({
    @Default(0) int id,
    @Default('') String slug,
    @Default('') String question,
    @JsonKey(name: 'categorie_empreinte') @Default('') String categorieEmpreinte,
    @Default('') String? icone,
    @JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre)
    @Default(TypeWidget.nombre)
    TypeWidget typeWidget,
    @JsonKey(name: 'config_json') @Default({}) Map<String, dynamic> config,
    @JsonKey(name: 'ordre_affichage') @Default(0) int ordre,
  }) = _QuestionBilanModel;

  factory QuestionBilanModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionBilanModelFromJson(json);

  // Conversion vers l'entité du domaine
  QuestionBilanEntity toEntity() {
    return QuestionBilanEntity(
      id: id,
      slug: slug,
      question: question,
      categorieEmpreinte: categorieEmpreinte,
      icone: icone,
      typeWidget: typeWidget,
      config: config,
      ordre: ordre,
    );
  }

  // Création depuis l'entité du domaine
  factory QuestionBilanModel.fromEntity(QuestionBilanEntity entity) {
    return QuestionBilanModel(
      id: entity.id,
      slug: entity.slug,
      question: entity.question,
      categorieEmpreinte: entity.categorieEmpreinte,
      icone: entity.icone,
      typeWidget: entity.typeWidget,
      config: entity.config,
      ordre: entity.ordre,
    );
  }
}
