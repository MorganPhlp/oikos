import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class VoteDefiUseCase {
  final DefisRepository repository;

  VoteDefiUseCase(this.repository);
  Future<void> call(String defiId, String communityCode, bool isJoining) {
    return repository.voteForDefiLaunch(defiId, communityCode, isJoining);
  }
}
