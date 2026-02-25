class VoteDefiEntity {
  final String defiId;
  final bool voteValue;

  const VoteDefiEntity({required this.defiId, required this.voteValue});
}

extension hasVotedExtension on List<VoteDefiEntity> {
  bool hasVotedForDefi(String defiId) {
    return any((vote) => vote.defiId == defiId);
  }
}
