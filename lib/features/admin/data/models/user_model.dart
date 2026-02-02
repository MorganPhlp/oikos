import 'package:oikos/features/admin/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.pseudo,
    required super.email,
    required super.communityId,
    super.avatarUrl,
    super.companyId,
  });

  /// Transforme le JSON de Supabase en UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      pseudo: (json['pseudo'] ?? json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      communityId: json['community_id'] as String?,
      companyId: json['company_id'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Transforme l'objet en Map pour les insertions ou mises à jour
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pseudo': pseudo,
      'email': email,
      'community_id': communityId?.isNotEmpty == true ? communityId : null,
      'company_id': companyId?.isNotEmpty == true ? companyId : null,
      'avatar_url': avatarUrl?.isNotEmpty == true ? avatarUrl : null,
    };
  }
}
