import 'package:oikos/features/admin/data/models/core/community.dart';
import 'package:oikos/features/admin/data/models/core/company.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';

class CommunityData {
  final List<Utilisateurs> users;
  final List<Community> communities;
  final List<Company> companies;

  CommunityData({
    required this.users,
    required this.communities,
    required this.companies,
  });
}
