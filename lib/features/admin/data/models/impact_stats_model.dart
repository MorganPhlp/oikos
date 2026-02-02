import 'package:oikos/features/admin/domain/entities/impact_stat_data.dart';

class ImpactStatDataModel extends ImpactStatData {

  
  ImpactStatDataModel({
    required super.activeMembers,
    required super.carEquivalent,
    required super.totalCo2Saved,
    required super.treeEquivalent,
  });

  factory ImpactStatDataModel.fromJson(Map<String, dynamic> json) {
    final double totalCo2Saved = json['total_co2_saved'];
    int treeEquivalent = ImpactConverter.toTrees(totalCo2Saved);
    double carEquivalent = ImpactConverter.toKm(totalCo2Saved);

    return ImpactStatDataModel(
      totalCo2Saved: totalCo2Saved,
      activeMembers: json['active_members'],
      carEquivalent: carEquivalent,
      treeEquivalent: treeEquivalent,
    );
  }
}


class ImpactConverter {
  // Constantes
  static const double co2PerTreePerYear = 25.0; // kg
  static const double co2PerKmCar = 0.19;       // kg/km

  /// Convertit le CO2 économisé en nombre d'arbres
  static int toTrees(double co2SavedKg) {
    return (co2SavedKg / co2PerTreePerYear).floor();
  }

  /// Convertit le CO2 économisé en kilomètres de voiture
  static double toKm(double co2SavedKg) {
    return co2SavedKg / co2PerKmCar;
  }
}