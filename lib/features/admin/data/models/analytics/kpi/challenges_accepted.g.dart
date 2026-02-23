// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_accepted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChallengesAcceptedKPI _$ChallengesAcceptedKPIFromJson(
  Map<String, dynamic> json,
) => _ChallengesAcceptedKPI(
  nbChallenges: json['nb_defis_releve'] as num,
  nbChallengesObjective: json['nb_defis_objectif'] as num,
);

Map<String, dynamic> _$ChallengesAcceptedKPIToJson(
  _ChallengesAcceptedKPI instance,
) => <String, dynamic>{
  'nb_defis_releve': instance.nbChallenges,
  'nb_defis_objectif': instance.nbChallengesObjective,
};
