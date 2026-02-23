import '../../../../core/common/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.pseudo,
    required super.communityCode,
    super.hasCompletedBilan = false,
    super.avatar,
    super.entrepriseId,
    super.isActive,
    super.impactScoreXp,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      pseudo: map['pseudo'] ?? '',
      communityCode: map['code_communaute'] ?? '',
      hasCompletedBilan: map['a_complete_bilan'] ?? false,
      avatar: map['avatar_url'],
      entrepriseId: map['entreprise_id'] ?? '',
      isActive: map['est_actif'] ?? true,
      impactScoreXp: map['impact_score_xp'] ?? 0,
    );
  }
}
