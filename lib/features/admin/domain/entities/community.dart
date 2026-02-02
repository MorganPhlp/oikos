import 'package:oikos/features/admin/domain/entities/company.dart';
import 'package:oikos/features/admin/domain/entities/user.dart' as u;

/// Modèle Community
class Community {
  final String id;
  final String name;
  final String code;
  final String companyId;
  final int membersCount;
  final double? avgScore;

  const Community({
    required this.id,
    required this.name,
    required this.code,
    required this.membersCount,
    required this.companyId,
    this.avgScore,
  });

  Community copyWith({
    String? id,
    String? name,
    String? code,
    int? membersCount,
    String? companyId,
    double? avgScore,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      membersCount: membersCount ?? this.membersCount,
      companyId: companyId ?? this.companyId,
      avgScore: avgScore ?? this.avgScore,
    );
  }
}

class CommunityData {
  final List<u.User> users;
  final List<Community> communities;
  final List<Company> companies;

  CommunityData({
    required this.users,
    required this.communities,
    required this.companies,
  });

  // Constructeur "from" : Utile pour cloner ou transformer
  factory CommunityData.from(CommunityData other) {
    return CommunityData(
      users: List<u.User>.from(other.users),
      communities: List<Community>.from(other.communities),
      companies: List<Company>.from(other.companies),
    );
  }

  // Permet de modifier une partie des données sans toucher au reste
  CommunityData copyWith({
    List<u.User>? users,
    List<Community>? communities,
    List<Company>? companies,
  }) {
    return CommunityData(
      users: users ?? this.users,
      communities: communities ?? this.communities,
      companies: companies ?? this.companies,
    );
  }
}
