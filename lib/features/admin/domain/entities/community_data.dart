import 'package:oikos/features/admin/domain/models/core/community.dart';
import 'package:oikos/features/admin/domain/models/core/company.dart';
import 'package:oikos/core/common/domain/entities/user.dart';

class CommunityData {
  final List<UserEntity> users;
  final List<Community> communities;
  final List<Company> companies;

  CommunityData({
    required this.users,
    required this.communities,
    required this.companies,
  });
}
