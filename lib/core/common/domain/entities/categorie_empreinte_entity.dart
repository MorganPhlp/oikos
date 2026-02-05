import 'package:freezed_annotation/freezed_annotation.dart';

// Les noms après 'part' doivent correspondre EXACTEMENT au nom du fichier sur le disque
part 'categorie_empreinte_entity.freezed.dart';
part 'categorie_empreinte_entity.g.dart';

@freezed
sealed class CategorieEmpreinteEntity with _$CategorieEmpreinteEntity {
  // Ajout du constructeur privé pour autoriser les getters (comme la conversion HEX -> Color)
  const CategorieEmpreinteEntity._();

  const factory CategorieEmpreinteEntity({
    @Default('') String nom,
    @Default('') String icone, 
    @Default('') String couleurHEX,
    @Default('') String description,
  }) = _CategorieEmpreinteEntity;
  
  factory CategorieEmpreinteEntity.fromJson(Map<String, dynamic> json) =>
      _$CategorieEmpreinteEntityFromJson(json);

  int get colorInt => int.parse(couleurHEX.replaceFirst('#', '0xff'));
}