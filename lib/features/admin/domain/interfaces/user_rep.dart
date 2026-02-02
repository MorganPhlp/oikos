import 'package:oikos/features/admin/domain/entities/user.dart';

abstract class UserRep {
  Future<void> updateUser(User user);
}
