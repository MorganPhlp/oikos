import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/models.dart';

part 'community_data.freezed.dart';

@freezed
sealed class CommunityData with _$CommunityData {
  const factory CommunityData({
    required List<Utilisateurs> users,
    required List<Community> communities,
  }) = _CommunityData;
}