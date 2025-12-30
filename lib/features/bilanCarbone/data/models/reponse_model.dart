import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reponse_entity.dart';

part 'reponse_model.freezed.dart';
part 'reponse_model.g.dart';

@freezed
sealed class ReponseUtilisateurModel with _$ReponseUtilisateurModel {
  const ReponseUtilisateurModel._();

  const factory ReponseUtilisateurModel({
    @JsonKey(includeIfNull: false) int? id,
    @JsonKey(name: 'bilan_id') @Default(0) int bilanId,
    @JsonKey(name: 'question_id') @Default(0) int questionId,
    dynamic valeur,
  }) = _ReponseUtilisateurModel;

  factory ReponseUtilisateurModel.fromJson(Map<String, dynamic> json) =>
      _$ReponseUtilisateurModelFromJson(json);

  // Conversion vers l'entité du domaine
  ReponseUtilisateurEntity toEntity() {
    return ReponseUtilisateurEntity(
      id: id,
      bilanId: bilanId,
      questionId: questionId,
      valeur: valeur,
    );
  }

  // Création depuis l'entité du domaine
  factory ReponseUtilisateurModel.fromEntity(ReponseUtilisateurEntity entity) {
    return ReponseUtilisateurModel(
      id: entity.id,
      bilanId: entity.bilanId,
      questionId: entity.questionId,
      valeur: entity.valeur,
    );
  }
}
