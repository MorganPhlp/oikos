
import 'package:oikos/features/admin/data/models/core/community.dart';
import 'package:oikos/features/admin/data/models/core/company.dart';
import 'package:oikos/core/domain/entities/user.dart';


class CommunityData {
  final List<User> users;
  final List<Community> communities;
  final List<Company> companies;

  CommunityData({
    required this.users,
    required this.communities,
    required this.companies,
  });
}