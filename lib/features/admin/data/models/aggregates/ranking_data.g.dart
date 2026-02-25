// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankingData _$RankingDataFromJson(Map<String, dynamic> json) => _RankingData(
  users: (json['users'] as List<dynamic>)
      .map((e) => Utilisateurs.fromJson(e as Map<String, dynamic>))
      .toList(),
  carbonFootPrints: (json['carbonFootPrints'] as List<dynamic>)
      .map((e) => CarbonFootPrint.fromJson(e as Map<String, dynamic>))
      .toList(),
  communities: (json['communities'] as List<dynamic>)
      .map((e) => Community.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RankingDataToJson(_RankingData instance) =>
    <String, dynamic>{
      'users': instance.users,
      'carbonFootPrints': instance.carbonFootPrints,
      'communities': instance.communities,
    };
