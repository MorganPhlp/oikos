import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';
import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';

abstract class DefisRepository {
  Future<List<DefiEntity>> getDefis(String communityCode);

  Future<void> voteForDefiLaunch(
    String defiId,
    String communityCode,
    bool isJoining,
  );
  Future<void> validateDefiParticipation(String defiId, String userId);

  Future<List<CommunityEntity>> getAvailableAdversaries(String communityCode);

  Future<Either<Failure, void>> proposeDuel({
    required String userId,
    required String targetCommunityCode,
    required String categorieNom,
    required int durationDays,
    String? titrePersonnalise,
  });

  Future<Either<Failure, List<VoteDefiEntity>>> fetchVotesDefis(String userId);
  Future<Either<Failure, List<ParticipationDefiEntity>>>
  fetchParticipationsDefis(String userId);
}
