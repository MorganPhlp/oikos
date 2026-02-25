import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';
import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class FetchVotesUseCase {
  final DefisRepository repository;

  FetchVotesUseCase(this.repository);

  Future<Either<Failure, List<VoteDefiEntity>>> call(String userId) async {
    return await repository.fetchVotesDefis(userId);
  }
}
