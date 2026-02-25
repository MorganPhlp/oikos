class ParticipationDefiEntity {
  final String defiId;
  final bool hasParticipated;

  const ParticipationDefiEntity({
    required this.defiId,
    required this.hasParticipated,
  });
}

// ignore: camel_case_extensions
extension hasParticipatedExtension on List<ParticipationDefiEntity> {
  bool hasParticipatedInDefi(String defiId) {
    return any((participation) => participation.defiId == defiId);
  }
}
