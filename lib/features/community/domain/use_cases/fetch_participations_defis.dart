import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';
import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class FetchParticipationsDefisUseCase {
  final DefisRepository repository;

  FetchParticipationsDefisUseCase(this.repository);

  Future<Either<Failure, List<ParticipationDefiEntity>>> call(
    String userId,
  ) async {
    return await repository.fetchParticipationsDefis(userId);
  }
}
