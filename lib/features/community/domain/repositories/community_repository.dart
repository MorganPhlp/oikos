import '../models/community_action_model.dart';
import '../models/defi_model.dart';
import '../models/leaderboard_entry_model.dart';

abstract interface class CommunityRepository {
  Future<List<CommunityActionModel>> getActions();

  Future<List<DefiModel>> getDefisCatalog(String entrepriseId);

  Future<List<DefiModel>> getActiveDefis(String entrepriseId);

  Future<bool> checkIfDefiValidatedToday(String defiId);

  Future<void> createCommunityChallenge({
    required String entrepriseId,
    required String actionId,
    String? titrePersonnalise,
    required int daysDuration,
  });

  Future<List<LeaderboardEntryModel>> getCommunityTopContributors(
    String communityCode,
  );

  Future<void> validateDefiAction({
    required String defiId,
    required String communityCode,
    required int xpGain,
  });

  Future<void> proposeDuel({
    required String defiId,
    required String myCommunityCode,
    required String targetCommunityCode,
    required String entrepriseId,
    required int durationDays,
  });

  Future<void> voteForDefiLaunch(String defiCommunauteId, String communityCode);

  Future<void> respondToChallenge(String challengeId, bool accept);

  Future<List<dynamic>> getMyCommunityDefis(String communauteCode);

  Future<List<LeaderboardEntryModel>> getUserLeaderboard(String communauteCode);

  Future<List<LeaderboardEntryModel>> getCommunityLeaderboard(
    String entrepriseId,
    String myCommunityCode,
  );

  Future<LeaderboardEntryModel?> getCommunityDetails(String communauteCode);

  Future<List<LeaderboardEntryModel>> getAdversaryCommunities(
    String entrepriseId,
    String myCode,
  );

  Future<List<dynamic>> getActiveChallenges(String entrepriseId);

  Future<void> validateCollectiveAction({
    required String instanceId,
    required String baseActionId,
    required String communityCode,
    required int xpGain,
  });

  Future<Map<String, dynamic>?> getMyMembership();

  Future<int> getRequiredVotes(String communityCode);

  Future<List<String>> getActiveActionIds(String companyId);

  Future<Map<String, dynamic>?> getExistingDuel(String from, String to);

  Future<void> proposeRandomDuel({
    required String targetCommunity,
    required String category,
    required int durationDays,
  });
}
