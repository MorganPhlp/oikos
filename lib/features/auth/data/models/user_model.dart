import '../../../../core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.pseudo,
    required super.communityCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      pseudo: map['pseudo'] ?? '',
      communityCode: map['community_code'] ?? '',
    );
  }
}
