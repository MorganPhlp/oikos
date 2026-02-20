import 'package:oikos/core/domain/entities/user.dart';

abstract class UserRep {
  Future<void> updateUser(User user);
}
