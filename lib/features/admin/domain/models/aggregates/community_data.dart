import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/features/admin/domain/models/models.dart';

part 'community_data.freezed.dart';

@freezed
sealed class CommunityData with _$CommunityData {
  const factory CommunityData({
    required List<UserEntity> users,
    required List<Community> communities,
  }) = _CommunityData;
}
