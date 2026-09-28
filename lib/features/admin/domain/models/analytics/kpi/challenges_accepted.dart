import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenges_accepted.freezed.dart';
part 'challenges_accepted.g.dart';

@freezed
sealed class ChallengesAcceptedKPI with _$ChallengesAcceptedKPI {
  const factory ChallengesAcceptedKPI({
    @JsonKey(name: 'nb_defis_releve') required num nbChallenges,
    @JsonKey(name: 'nb_defis_objectif') required num nbChallengesObjective,
  }) = _ChallengesAcceptedKPI;

  factory ChallengesAcceptedKPI.fromJson(Map<String, dynamic> json) =>
      _$ChallengesAcceptedKPIFromJson(json);
}
