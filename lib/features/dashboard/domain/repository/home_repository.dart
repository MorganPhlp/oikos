import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, String>> getMyPseudo();
}
