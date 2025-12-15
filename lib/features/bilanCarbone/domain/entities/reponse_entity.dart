import 'package:freezed_annotation/freezed_annotation.dart';

part 'reponse_entity.freezed.dart';
part 'reponse_entity.g.dart';

@freezed
sealed class ReponseUtilisateurEntity with _$ReponseUtilisateurEntity {
  const ReponseUtilisateurEntity._();

  const factory ReponseUtilisateurEntity({
    @Default(0) int id,
    @JsonKey(name: 'bilan_id') @Default(0) int bilanId,
    @JsonKey(name: 'question_id') @Default(0) int questionId,
    @Default(null) dynamic valeur, 
  }) = _ReponseUtilisateurEntity;

  factory ReponseUtilisateurEntity.fromJson(Map<String, dynamic> json) =>
      _$ReponseUtilisateurEntityFromJson(json);
      
  bool get isNumeric => valeur is num;
  double? get asDouble => (valeur as num?)?.toDouble();
}