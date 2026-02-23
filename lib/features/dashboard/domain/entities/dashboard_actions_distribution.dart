class DashboardActionsDistribution {
  /// Map label catégorie bilan -> nombre d'actions réalisées (ou score associé).
  final Map<String, double> countsByCategoryLabel;

  const DashboardActionsDistribution({
    required this.countsByCategoryLabel,
  });
}
