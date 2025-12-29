import 'package:freezed_annotation/freezed_annotation.dart';
part 'carbone_equivalent_entity.freezed.dart';
part 'carbone_equivalent_entity.g.dart';

@freezed
sealed class CarboneEquivalentEntity with _$CarboneEquivalentEntity {

  const factory CarboneEquivalentEntity({
    @Default(0) int id,
    @JsonKey(name: 'equivalent_label') @Default('') String equivalentLabel,
    @JsonKey(name: 'valeur_1_tonne') @Default(0.0) double valeur1Tonne,
  }) = _CarboneEquivalentEntity;

  factory CarboneEquivalentEntity.fromJson(Map<String, dynamic> json) =>
      _$CarboneEquivalentEntityFromJson(json);
}