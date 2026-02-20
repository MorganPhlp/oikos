import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'global_insights_card.dart';

class GlobalInsightsKPIs extends StatelessWidget {
  /// Données des statistiques (null si pas encore chargées)
  final GlobalInsightsStats? stats;
  
  /// Affiche l'état de chargement
  final bool isLoading;
  
  /// Tendances optionnelles (à calculer côté backend ou localement)
  final KPITrend? usersTrend;
  final KPITrend? retentionTrend;

  const GlobalInsightsKPIs({
    super.key,
    this.stats,
    this.isLoading = false,
    this.usersTrend,
    this.retentionTrend,
  });

  @override
  Widget build(BuildContext context) {
    // Formatters
    final numberFormat = NumberFormat('#,##0', 'fr_FR');
    final decimalFormat = NumberFormat('#,##0.0', 'fr_FR');

    return KPICardsGrid(
      cards: [
        // CO₂ Total Économisé
        KPICard(
          title: 'CO₂ Total Économisé',
          value: stats != null 
              ? decimalFormat.format(stats!.totalCo2Saved)
              : '0',
          unit: 'tonnes',
          icon: Icons.trending_down,
          color: KPIColor.green,
          isLoading: isLoading,
        ),
        
        // Utilisateurs Actifs
        KPICard(
          title: 'Utilisateurs Actifs',
          value: stats != null 
              ? numberFormat.format(stats!.activeUsers.toInt())
              : '0',
          icon: Icons.people,
          color: KPIColor.blue,
          isLoading: isLoading,
        ),
        
        // Défis Actifs (Relevés)
        KPICard(
          title: 'Défis Relevés',
          value: stats != null 
              ? numberFormat.format(stats!.activeChallenges)
              : '0',
          icon: Icons.flag,
          color: KPIColor.purple,
          isLoading: isLoading,
        ),
        
        // Taux de Rétention
        KPICard(
          title: 'Taux de Rétention',
          value: stats != null 
              ? stats!.retentionRate.toString()
              : '0',
          unit: '%',
          icon: Icons.refresh,
          color: KPIColor.orange,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
