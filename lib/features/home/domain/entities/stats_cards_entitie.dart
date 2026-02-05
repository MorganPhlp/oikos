import 'package:flutter/foundation.dart';

class StatsCardsEntitie {
  final String icon;
  final double value;
  final String unit;
  final String text1;
  final String? text2;

  const StatsCardsEntitie({
   required this.icon,
   required this.value,
   required this.unit,
   required this.text1,
   this.text2
  });

 factory StatsCardsEntitie.mock1() {
    return const StatsCardsEntitie(
      icon: '🌿',
      value: 12.5,
      unit: 'kg CO₂',
      text1: 'Émissions de la semaine',
      text2: '10% de moins que la semaine dernière',
    );
  }

  factory StatsCardsEntitie.mock2() {
    return const StatsCardsEntitie(
      icon: '🚗',
      value: 150.0,
      unit: 'km',
      text1: 'Distance parcourue en voiture ce mois-ci',
    );
  }

  factory StatsCardsEntitie.mock3() {
    return const StatsCardsEntitie(
      icon: '🍽️',
      value: 8.0,
      unit: 'repas',
      text1: 'Repas végétariens cette semaine',
      text2: '20% de plus que la semaine dernière',
    );
  }
}