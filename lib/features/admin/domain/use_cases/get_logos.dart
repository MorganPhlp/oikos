import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/interfaces/logos_rep.dart';

class GetLogos {
  final LogosRep repository;

  GetLogos(this.repository);

  Future<Either<Failure, List<String>>> call(String companyName) async {
    final logosResult = await repository.getLogos(companyName);
    return logosResult.fold(
      (failure) => left(failure),
      (logos) => right(logos),
    );
  }

  Future<Either<Failure, List<String>>> getAvatars() async {
    final result = await repository.getAvatars();
    return result.fold(
      (failure) => left(failure),
      (avatars) => right(avatars),
    );
  }
}
