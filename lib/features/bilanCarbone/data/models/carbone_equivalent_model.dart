import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/carbone_equivalent_entity.dart';

part 'carbone_equivalent_model.freezed.dart';
part 'carbone_equivalent_model.g.dart';

@freezed
sealed class CarboneEquivalentModel with _$CarboneEquivalentModel {
  const CarboneEquivalentModel._();

  const factory CarboneEquivalentModel({
    @Default(0) int id,
    @JsonKey(name: 'equivalent_label') @Default('') String equivalentLabel,
    @JsonKey(name: 'valeur_1_tonne') @Default(0.0) double valeur1Tonne,
    @JsonKey(name: 'icone') String? icone,
  }) = _CarboneEquivalentModel;

  factory CarboneEquivalentModel.fromJson(Map<String, dynamic> json) =>
      _$CarboneEquivalentModelFromJson(json);

  // Conversion vers l'entité du domaine
  CarboneEquivalentEntity toEntity() {
    return CarboneEquivalentEntity(
      id: id,
      equivalentLabel: equivalentLabel,
      valeur1Tonne: valeur1Tonne,
      icone: icone,
    );
  }

  // Création depuis l'entité du domaine
  factory CarboneEquivalentModel.fromEntity(CarboneEquivalentEntity entity) {
    return CarboneEquivalentModel(
      id: entity.id,
      equivalentLabel: entity.equivalentLabel,
      valeur1Tonne: entity.valeur1Tonne,
    );
  }
}
