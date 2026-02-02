import 'package:flutter/material.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/domain/entities/impact_stat_data.dart';
import 'impact_stat_card.dart';

class ImpactStats extends StatelessWidget {
  final ImpactStatData? data;

  const ImpactStats({super.key, this.data});

  /// Génère les données des cartes à partir de ImpactStatData ou utilise les valeurs par défaut
  List<_StatData> get _statsData {
    if (data != null) {
      // Données dynamiques
      return [
        _StatData(
          title: "Réduction CO2",
          value: "${data!.totalCo2Saved.toStringAsFixed(2)} kg CO2e",
          icon: Icons.trending_down,
          badgeText: "Totale",
          gradientColors: const [Color(0xFF22C55E), Color(0xFF16A34A)],
        ),
        _StatData(
          title: "Arbres plantés",
          value: "${data!.treeEquivalent} arbres",
          icon: Icons.park,
          badgeText: "Equivalent",
          gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
        ),
        _StatData(
          title: "Km de voiture évités",
          value: "${data!.carEquivalent.toStringAsFixed(2)} km",
          icon: Icons.directions_car,
          badgeText: "Equivalent",
          gradientColors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        _StatData(
          title: "Suivi",
          value: "${data!.activeMembers} membres",
          icon: Icons.calendar_today,
          badgeText: "Suivi",
          gradientColors: const [Color(0xFFA855F7), Color(0xFF9333EA)],
        ),
      ];
    }

    // Données par défaut (placeholder)
    return const [
      _StatData(
        title: "Réduction CO2",
        value: "-- kg",
        icon: Icons.trending_down,
        badgeText: "Ce mois",
        gradientColors: [Color(0xFF22C55E), Color(0xFF16A34A)],
      ),
      _StatData(
        title: "Arbres équivalents",
        value: "-- arbres",
        icon: Icons.park,
        badgeText: "Plantés",
        gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
      ),
      _StatData(
        title: "Km évités",
        value: "-- km",
        icon: Icons.directions_car,
        badgeText: "En voiture",
        gradientColors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      ),
      _StatData(
        title: "Jours actifs",
        value: "-- jours",
        icon: Icons.calendar_today,
        badgeText: "Streak",
        gradientColors: [Color(0xFFA855F7), Color(0xFF9333EA)],
      ),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final config = _getGridConfig(width);

        // Sur tablet/desktop : utiliser une grille
        return _buildGrid(config);
      },
    );
  }

  /// Configuration de la grille selon la largeur
  _GridConfig _getGridConfig(double width) {
    // Mobile small : scroll horizontal avec cartes compactes
    if (width < Breakpoints.mobile) {
      return _GridConfig(
        crossAxisCount: 1,
        spacing: 12,
        childAspectRatio: 2.8,
        cardHeight: 90,
        cardWidth: width * 0.75,
      );
    }
    if (width < Breakpoints.tablet) {
      return _GridConfig(
        crossAxisCount: 2,
        spacing: 16,
        childAspectRatio: 2.2,
      );
    }
    // Desktop : 2 colonnes plus larges
    if (width < Breakpoints.desktop) {
      return _GridConfig(
        crossAxisCount: 2,
        spacing: 20,
        childAspectRatio: 2.4,
      );
    }
    // Très grand écran : 4 colonnes avec ratio ajusté
    return _GridConfig(
      crossAxisCount: 4,
      spacing: 24,
      childAspectRatio: 2.3,
    );
  }

  /// Grille responsive pour tablet/desktop
  Widget _buildGrid(_GridConfig config) {
    final stats = _statsData;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.crossAxisCount,
        crossAxisSpacing: config.spacing,
        mainAxisSpacing: config.spacing,
        childAspectRatio: config.childAspectRatio,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return ImpactStatCard(
          title: stat.title,
          value: stat.value,
          icon: stat.icon,
          badgeText: stat.badgeText,
          gradientColors: stat.gradientColors,
          isLoading: data == null, // Affiche un état loading si pas de données
        );
      },
    );
  }

}

/// Configuration de la grille
class _GridConfig {
  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;
  final double cardHeight;
  final double cardWidth;

  const _GridConfig({
    required this.crossAxisCount,
    required this.spacing,
    required this.childAspectRatio,
    this.cardHeight = 120,
    this.cardWidth = 280,
  });
}

/// Données d'une statistique (interne)
class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final String badgeText;
  final List<Color> gradientColors;

  const _StatData({
    required this.title,
    required this.value,
    required this.icon,
    required this.badgeText,
    required this.gradientColors,
  });
}