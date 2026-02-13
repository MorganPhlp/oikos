class UtilisateurStreakEntity {
  final String utilisateurId;
  final int currentStreak;
  final DateTime lastUpdated;
  final String? saisonNom;
  final DateTime? saisonDebut;
  final DateTime? saisonFin;
  final String? logoUrl;

  UtilisateurStreakEntity({
    required this.utilisateurId,
    required this.currentStreak,
    required this.lastUpdated,
    this.saisonNom,
    this.saisonDebut,
    this.saisonFin,
    this.logoUrl,
  });

  factory UtilisateurStreakEntity.empty() {
    return UtilisateurStreakEntity(
      utilisateurId: '',
      currentStreak: 0,
      lastUpdated: DateTime.now(),
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
  }) {
    return UtilisateurStreakEntity(
      utilisateurId: utilisateurId ?? this.utilisateurId,
      currentStreak: currentStreak ?? this.currentStreak,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      saisonNom: saisonNom ?? this.saisonNom,
      saisonDebut: saisonDebut ?? this.saisonDebut,
      saisonFin: saisonFin ?? this.saisonFin,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
  @override
  String toString() {
    return 'UtilisateurStreakEntity(id: $utilisateurId, streak: $currentStreak, updated: $lastUpdated, saison: $saisonNom, logo: $logoUrl)';
  }
}
