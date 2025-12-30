import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/objectif_entity.dart';

part 'objectif_model.freezed.dart';
part 'objectif_model.g.dart';

@freezed
sealed class ObjectifModel with _$ObjectifModel {
  const ObjectifModel._();

  const factory ObjectifModel({
    required double valeur,
    required String label,
    required String description,
    required List<int> colors,
  }) = _ObjectifModel;

  factory ObjectifModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectifModelFromJson(json);

  // Conversion vers l'entité du domaine
  ObjectifEntity toEntity() {
    return ObjectifEntity(
      valeur: valeur,
      label: label,
      description: description,
      colors: colors,
    );
  }

  // Création depuis l'entité du domaine
  factory ObjectifModel.fromEntity(ObjectifEntity entity) {
    return ObjectifModel(
      valeur: entity.valeur,
      label: entity.label,
      description: entity.description,
      colors: entity.colors,
    );
  }
}
