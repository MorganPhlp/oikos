// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreakStepModel _$StreakStepModelFromJson(Map<String, dynamic> json) =>
    _StreakStepModel(
      from: (json['from_streak_phase'] as num).toInt(),
      to: (json['to_streak_phase'] as num).toInt(),
      requiredActionsIndividuelles:
          (json['required_actions_individuelles'] as num).toInt(),
      requiredActionsCommunautaires:
          (json['required_actions_communautaires'] as num).toInt(),
    );

Map<String, dynamic> _$StreakStepModelToJson(_StreakStepModel instance) =>
    <String, dynamic>{
      'from_streak_phase': instance.from,
      'to_streak_phase': instance.to,
      'required_actions_individuelles': instance.requiredActionsIndividuelles,
      'required_actions_communautaires': instance.requiredActionsCommunautaires,
    };
