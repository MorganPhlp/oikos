import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/features/streak/domain/entities/streak_step_entity.dart';

part 'streak_step_model.freezed.dart';
part 'streak_step_model.g.dart';

@freezed
sealed class StreakStepModel with _$StreakStepModel {
  const StreakStepModel._();

  const factory StreakStepModel({
    @JsonKey(name: 'from_streak_phase') required int from,
    @JsonKey(name: 'to_streak_phase') required int to,
    @JsonKey(name: 'required_actions_quotidiennes')
    required int requiredActionsQuotidiennes,
    @JsonKey(name: 'required_actions_communautaires')
    required int requiredActionsCommunautaires,
  }) = _StreakStepModel;

  factory StreakStepModel.fromJson(Map<String, dynamic> json) =>
      _$StreakStepModelFromJson(json);

  StreakStepEntity toEntity() {
    return StreakStepEntity(
      from: from,
      to: to,
      requiredActionsQuotidiennes: requiredActionsQuotidiennes,
      requiredActionsCommunautaires: requiredActionsCommunautaires,
    );
  }
}
