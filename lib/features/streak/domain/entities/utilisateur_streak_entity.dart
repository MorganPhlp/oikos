class UtilisateurStreakEntity {
  final String utilisateurId;
  final int currentStreak;
  final DateTime? lastUpdated;
  final String? saisonNom;
  final DateTime? saisonDebut;
  final DateTime? saisonFin;
  final String? logoUrl;
  final int? lastStreakSeen;

  UtilisateurStreakEntity({
    required this.utilisateurId,
    required this.currentStreak,
    required this.lastUpdated,
    this.saisonNom,
    this.saisonDebut,
    this.saisonFin,
    this.logoUrl,
    this.lastStreakSeen = 0,
  });

  factory UtilisateurStreakEntity.empty() {
    return UtilisateurStreakEntity(
      utilisateurId: '',
      currentStreak: 0,
      lastUpdated: DateTime.now(),
      lastStreakSeen: 0,
    );
  }

  UtilisateurStreakEntity copyWith({
    String? utilisateurId,
    int? currentStreak,
    DateTime? lastUpdated,
    String? saisonNom,
    DateTime? saisonDebut,
    DateTime? saisonFin,
    String? logoUrl,
    int? lastStreakSeen,
  }) {
    return UtilisateurStreakEntity(
      utilisateurId: utilisateurId ?? this.utilisateurId,
      currentStreak: currentStreak ?? this.currentStreak,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      saisonNom: saisonNom ?? this.saisonNom,
      saisonDebut: saisonDebut ?? this.saisonDebut,
      saisonFin: saisonFin ?? this.saisonFin,
      logoUrl: logoUrl ?? this.logoUrl,
      lastStreakSeen: lastStreakSeen ?? this.lastStreakSeen,
    );
  }

  @override
  String toString() {
    return 'UtilisateurStreakEntity(id: $utilisateurId, streak: $currentStreak, updated: $lastUpdated, saison: $saisonNom, logo: $logoUrl, lastSeen: $lastStreakSeen)';
  }
}
