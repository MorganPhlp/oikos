import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/community/data/datasources/defis_remote_datasrouce.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';
import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';
import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class DefiRepositoryImpl extends DefisRepository {
  final DefisRemoteDatasrouce remoteDataSource;

  DefiRepositoryImpl(this.remoteDataSource);
  @override
  Future<List<DefiEntity>> getDefis(String communityCode) {
    return remoteDataSource.getDefis(communityCode);
  }

  @override
  Future<void> validateDefiParticipation(String defiId, String userId) {
    return remoteDataSource.validateDefiParticipation(defiId, userId);
  }

  @override
  Future<void> voteForDefiLaunch(
    String defiId,
    String communityCode,
    bool isJoining,
  ) {
    return remoteDataSource.voteForDefiLaunch(defiId, communityCode, isJoining);
  }

  @override
  Future<List<CommunityEntity>> getAvailableAdversaries(
    String communityCode,
  ) async {
    return await remoteDataSource.getCommunities(communityCode);
  }

  @override
  Future<Either<Failure, void>> proposeDuel({
    required String userId,
    required String targetCommunityCode,
    required String categorieNom,
    required int durationDays,
    String? titrePersonnalise,
  }) {
    return remoteDataSource.proposeDuel(
      userId: userId,
      targetCommunityCode: targetCommunityCode,
      categorieNom: categorieNom,
      durationDays: durationDays,
      titrePersonnalise: titrePersonnalise,
    );
  }

  @override
  Future<Either<Failure, List<ParticipationDefiEntity>>>
  fetchParticipationsDefis(String userId) async {
    final result = await remoteDataSource.fetchParticipationsDefis(userId);

    // On transforme le Right(List<ParticipationDefiModel>)
    // en Right(List<ParticipationDefiEntity>)
    return result.map(
      (models) => models.cast<ParticipationDefiEntity>().toList(),
    );
  }

  @override
  Future<Either<Failure, List<VoteDefiEntity>>> fetchVotesDefis(
    String userId,
  ) async {
    final result = await remoteDataSource.fetchVotesDefis(userId);

    return result.map(
      (models) => models.map((model) => model as VoteDefiEntity).toList(),
    );
  }
}
