import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_model.freezed.dart';
part 'streak_model.g.dart';

@freezed
sealed class StreakModel with _$StreakModel {
  const StreakModel._();

  const factory StreakModel({
    @JsonKey(name: 'utilisateur_id') required String utilisateurId,
    @JsonKey(name: 'effective_streak') required int currentStreak,
    @JsonKey(name: 'last_updated') required DateTime lastUpdated,
    @JsonKey(name: 'saison_nom') String? saisonNom,
    @JsonKey(name: 'saison_debut') DateTime? saisonDebut,
    @JsonKey(name: 'saison_fin') DateTime? saisonFin,
  }) = _StreakModel;

  factory StreakModel.fromJson(Map<String, dynamic> json) =>
      _$StreakModelFromJson(json);
}
