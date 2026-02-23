import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

abstract class LogosRep {
  Future<Either<Failure, List<String>>> getLogos();
  Future<Either<Failure, List<String>>> getAvatars();
  // Future<Either<Failure, void>> addLogo(String logo);
}
