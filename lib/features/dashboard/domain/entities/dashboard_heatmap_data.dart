class DashboardHeatmapData {
  final DateTime minDate;
  final DateTime maxDate;

  /// Map de comptes par jour (clé normalisée en local: yyyy-mm-dd à minuit).
  final Map<DateTime, int> dailyCounts;

  const DashboardHeatmapData({
    required this.minDate,
    required this.maxDate,
    required this.dailyCounts,
  });
}
