import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/core/error/failures.dart';

abstract class UserRep {
  Future<Either<Failure, void>> updateUser(User user);
}
