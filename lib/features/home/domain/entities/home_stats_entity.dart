class HomeStatsEntity {
  /// Nombre total d'actions réalisées
  final int nbActionsRealisees;

  /// Total XP gagné via les actions
  final int totalXpGagne;

  /// Score XP de l'utilisateur
  final int impactScoreXp;

  /// Nombre d'actions en cours
  final int nbActionsEnCours;

  /// Nombre d'habitudes
  final int nbHabitudes;

  /// Score total CO2 annuel (en kg CO₂/an) du dernier bilan
  final double? scoreTotalCo2;

  /// Catégorie la plus émettrice (Transport, Alimentation, Logement, Divers, Services sociétaux)
  final String? categoriePlusEmettrice;

  /// Valeur en kg CO₂ de la catégorie la plus émettrice
  final double? valeurCategorieMax;

  /// Détails par catégorie
  final double transport;
  final double alimentation;
  final double logement;
  final double divers;
  final double servicesSocietaux;

  const HomeStatsEntity({
    required this.nbActionsRealisees,
    required this.totalXpGagne,
    required this.impactScoreXp,
    this.nbActionsEnCours = 0,
    this.nbHabitudes = 0,
    this.scoreTotalCo2,
    this.categoriePlusEmettrice,
    this.valeurCategorieMax,
    this.transport = 0,
    this.alimentation = 0,
    this.logement = 0,
    this.divers = 0,
    this.servicesSocietaux = 0,
  });
}
