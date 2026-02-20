import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/features/admin/data/models/core/community.dart';
import 'package:oikos/features/admin/data/models/core/company.dart';
import 'package:oikos/core/domain/entities/user.dart';

part 'community_data.freezed.dart';
part 'community_data.g.dart';

@freezed
sealed class CommunityData with _$CommunityData {
  const factory CommunityData({
    
    @JsonSerializable(explicitToJson: true)
    required List<User> users,
    
    @JsonSerializable(explicitToJson: true)
    required List<Community> communities,
    
    
    @JsonSerializable(explicitToJson: true)
    required List<Company> companies,
  }) = _CommunityData;

  factory CommunityData.fromJson(Map<String, dynamic> json) => _$CommunityDataFromJson(json);
}
