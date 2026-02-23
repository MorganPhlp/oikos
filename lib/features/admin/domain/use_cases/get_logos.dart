import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/logos_rep.dart';

class GetLogos {
  final LogosRep repository;

  GetLogos(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    final logosResult = await repository.getLogos();
    return logosResult.fold(
      (failure) => left(failure),
      (logos) => right(logos),
    );
  }
}
