import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, String>> getMyPseudo();
}
