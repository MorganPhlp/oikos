import 'dart:convert';

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
    @JsonKey(fromJson: _parseValeur) dynamic valeur,
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

dynamic _parseValeur(dynamic raw) {
  if (raw == null) return null;

  // Déjà bien typé
  if (raw is num || raw is bool || raw is List || raw is Map) {
    return raw;
  }

  if (raw is String) {
    // Int
    final intValue = int.tryParse(raw);
    if (intValue != null) return intValue;

    // Double
    final doubleValue = double.tryParse(raw);
    if (doubleValue != null) return doubleValue;

    // Bool
    if (raw.toLowerCase() == 'true') return true;
    if (raw.toLowerCase() == 'false') return false;

    // List JSON (ex: "[1,2,3]" ou ["val1","val2"])
    if (raw.startsWith('[') && raw.endsWith(']')) {
      try {
        return List<dynamic>.from(jsonDecode(raw));
      } catch (_) {}
    }

    // Map JSON (ex: '{"cle1": 2, "cle2": 3}')
    if (raw.startsWith('{') && raw.endsWith('}')) {
      try {
        return Map<String, dynamic>.from(jsonDecode(raw));
      } catch (_) {}
    }
  }

  // Fallback : on garde la valeur brute
  return raw;
}
