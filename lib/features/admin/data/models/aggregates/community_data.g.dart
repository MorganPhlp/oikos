// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunityData _$CommunityDataFromJson(Map<String, dynamic> json) =>
    _CommunityData(
      users: (json['users'] as List<dynamic>)
          .map((e) => Utilisateurs.fromJson(e as Map<String, dynamic>))
          .toList(),
      communities: (json['communities'] as List<dynamic>)
          .map((e) => Community.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommunityDataToJson(_CommunityData instance) =>
    <String, dynamic>{
      'users': instance.users,
      'communities': instance.communities,
    };
