import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/logos_rep.dart';

class GetAvatars {
  final LogosRep repository;

  GetAvatars(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    final avatarsResult = await repository.getAvatars();
    return avatarsResult.fold(
      (failure) => left(failure),
      (avatars) => right(avatars),
    );
  }
}
