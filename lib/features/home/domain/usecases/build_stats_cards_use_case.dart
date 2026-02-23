import 'dart:math';

import 'package:oikos/features/home/domain/entities/home_stats_entity.dart';
import 'package:oikos/features/home/domain/entities/stats_cards_entitie.dart';

/// Nombre max de cartes affichées dans le carrousel.
const int _maxDisplayedCards = 4;

/// Nombre max de cartes "alerte" affichées (le reste sera positif).
const int _maxAlertCards = 1;

/// Moyenne française en t CO₂/an (source ADEME).
const double _moyenneFrancaiseTonnes = 9.9;

class BuildStatsCardsUseCase {
  /// Génère les cartes en séparant positives et alertes,
  /// puis compose un carrousel majoritairement encourageant.
  List<StatsCardsEntitie> call(HomeStatsEntity stats) {
    final positiveCards = <StatsCardsEntitie>[];
    final alertCards = <StatsCardsEntitie>[];

    // ── Cartes positives ──
    _addEmpreintePositiveCard(positiveCards, stats);
    _addActionsRealiseesCard(positiveCards, stats);
    _addActionsEnCoursCard(positiveCards, stats);
    _addHabitudesCard(positiveCards, stats);
    _addScoreXpCard(positiveCards, stats);
    _addTotalXpGagneCard(positiveCards, stats);
    _addEmpreinteFaibleCategorie(positiveCards, stats);

    // ── Cartes alerte (ton lucide mais bienveillant) ──
    _addEmpreinteAlertCard(alertCards, stats);
    _addComparaisonAlertCard(alertCards, stats);
    _addCategoriePlusEmettriceCard(alertCards, stats);

    // Cas sans données : message d'encouragement
    if (positiveCards.isEmpty && alertCards.isEmpty) {
      return const [
        StatsCardsEntitie(
          icon: '🌱',
          value: 0,
          unit: '',
          text1: 'Commence ton bilan carbone',
          text2: 'Découvre ton empreinte et agis !',
        ),
      ];
    }

    final rng = Random();

    // Mélange et sélection des alertes (max _maxAlertCards)
    alertCards.shuffle(rng);
    final selectedAlerts = alertCards.take(_maxAlertCards).toList();

    // Mélange des positives et complète le reste
    positiveCards.shuffle(rng);
    final nbPositiveSlots = _maxDisplayedCards - selectedAlerts.length;
    final selectedPositives = positiveCards.take(nbPositiveSlots).toList();

    // Compose le résultat final et mélange l'ordre de présentation
    final result = [...selectedPositives, ...selectedAlerts];
    result.shuffle(rng);

    return result;
  }

  // ═══════════════════════════════════════════════════════════
  //  CARTES POSITIVES / ENCOURAGEANTES
  // ═══════════════════════════════════════════════════════════

  // ── Empreinte : version positive (si en dessous de 8t) ────
  void _addEmpreintePositiveCard(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.scoreTotalCo2 == null || s.scoreTotalCo2! <= 0) return;
    final tonnes = s.scoreTotalCo2! / 1000;
    if (tonnes > 8) return; // Pas positive si trop haut
    cards.add(
      StatsCardsEntitie(
        icon: '🌍',
        value: tonnes,
        unit: 't CO₂/an',
        text1: 'Ton empreinte carbone',
        text2: tonnes <= 2
            ? 'Extraordinaire, objectif climat atteint !'
            : tonnes <= 5
            ? 'Super résultat, continue comme ça !'
            : 'En bonne voie, chaque geste compte !',
      ),
    );
  }

  // ── Actions réalisées ─────────────────────────────────────
  void _addActionsRealiseesCard(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.nbActionsRealisees <= 0) return;
    cards.add(
      StatsCardsEntitie(
        icon: '🎯',
        value: s.nbActionsRealisees.toDouble(),
        unit: s.nbActionsRealisees == 1 ? 'action' : 'actions',
        text1: 'Actions réalisées',
        text2: s.nbActionsRealisees >= 50
            ? 'Un vrai champion  !'
            : s.nbActionsRealisees >= 10
            ? 'C\'est super, continue ! '
            : 'Chaque action fait la différence ',
      ),
    );
  }

  // ── Actions en cours ──────────────────────────────────────
  void _addActionsEnCoursCard(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.nbActionsEnCours <= 0) return;
    cards.add(
      StatsCardsEntitie(
        icon: '🎯',
        value: s.nbActionsEnCours.toDouble(),
        unit: 'Actions',
        text1: 'en cours',
        text2: s.nbActionsEnCours >= 5
            ? 'On peut compter sur toi, bravo !'
            : 'Tu progresses, continue !',
      ),
    );
  }

  // ── Habitudes ─────────────────────────────────────────────
  void _addHabitudesCard(List<StatsCardsEntitie> cards, HomeStatsEntity s) {
    if (s.nbHabitudes <= 0) return;
    cards.add(
      StatsCardsEntitie(
        icon: '💚',
        value: s.nbHabitudes.toDouble(),
        unit: s.nbHabitudes == 1 ? 'habitude' : 'habitudes',
        text1: 'Habitudes éco dans ton mode de vie',
        text2: s.nbHabitudes >= 3
            ? 'L\'écologie est dans ton ADN !'
            : 'Beau début, les habitudes changent tout !',
      ),
    );
  }

  // ── Score XP ──────────────────────────────────────────────
  void _addScoreXpCard(List<StatsCardsEntitie> cards, HomeStatsEntity s) {
    if (s.impactScoreXp <= 0) return;
    cards.add(
      StatsCardsEntitie(
        icon: '⭐',
        value: s.impactScoreXp.toDouble(),
        unit: 'XP',
        text1: 'Score d\'impact',
        text2: s.impactScoreXp >= 100
            ? 'Champion de l\'écologie ! '
            : s.impactScoreXp >= 50
            ? 'Bel engagement, ça monte ! '
            : 'Ton impact grandit jour après jour',
      ),
    );
  }

  // ── Total XP gagné via actions ────────────────────────────
  void _addTotalXpGagneCard(List<StatsCardsEntitie> cards, HomeStatsEntity s) {
    if (s.totalXpGagne <= 0) return;
    cards.add(
      StatsCardsEntitie(
        icon: '🏆',
        value: s.totalXpGagne.toDouble(),
        unit: 'XP',
        text1: 'XP gagnés via tes actions',
        text2: s.totalXpGagne >= 500
            ? 'Tu déchires ! '
            : 'Chaque action te rapproche du sommet',
      ),
    );
  }

  // ── Catégorie la plus faible (point fort) ──────────────────
  void _addEmpreinteFaibleCategorie(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.scoreTotalCo2 == null || s.scoreTotalCo2! <= 0) return;

    final categories = {
      'Transport': (s.transport, '🚗'),
      'Alimentation': (s.alimentation, '🍽️'),
      'Logement': (s.logement, '🏠'),
      'Divers': (s.divers, '📦'),
      'Services sociétaux': (s.servicesSocietaux, '🏛️'),
    };

    // Trouver la catégorie avec la plus faible empreinte > 0
    String? bestCat;
    double bestVal = double.infinity;
    String bestIcon = '📊';
    for (final entry in categories.entries) {
      final val = entry.value.$1;
      if (val > 0 && val < bestVal) {
        bestVal = val;
        bestCat = entry.key;
        bestIcon = entry.value.$2;
      }
    }
    if (bestCat == null) return;

    cards.add(
      StatsCardsEntitie(
        icon: bestIcon,
        value: bestVal / 1000,
        unit: 't CO₂/an',
        text1: '$bestCat : ton point fort !',
        text2: 'Ta catégorie la plus vertueuse ',
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  CARTES ALERTE (lucides mais bienveillantes)
  // ═══════════════════════════════════════════════════════════

  // ── Empreinte : version alerte (si au-dessus de 8t) ───────
  void _addEmpreinteAlertCard(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.scoreTotalCo2 == null || s.scoreTotalCo2! <= 0) return;
    final tonnes = s.scoreTotalCo2! / 1000;
    if (tonnes <= 8) return; // Pas alerte si correct
    cards.add(
      StatsCardsEntitie(
        icon: '🌍',
        value: tonnes,
        unit: 't CO₂/an',
        text1: 'Ton empreinte carbone',
        text2: 'Tes actions peuvent la réduire, lance-toi !',
      ),
    );
  }

  // ── Comparaison moyenne : version alerte ──────────────────
  void _addComparaisonAlertCard(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.scoreTotalCo2 == null || s.scoreTotalCo2! <= 0) return;
    final tonnes = s.scoreTotalCo2! / 1000;
    if (tonnes < _moyenneFrancaiseTonnes) return;
    final diff = (tonnes - _moyenneFrancaiseTonnes);
    cards.add(
      StatsCardsEntitie(
        icon: '📈',
        value: diff,
        unit: 't CO₂/an',
        text1: 'de plus que la moyenne 🇫🇷',
        text2: 'Avec tes actions, tu peux y arriver',
      ),
    );
  }

  // ── Catégorie la plus émettrice ───────────────────────────
  void _addCategoriePlusEmettriceCard(
    List<StatsCardsEntitie> cards,
    HomeStatsEntity s,
  ) {
    if (s.categoriePlusEmettrice == null ||
        s.valeurCategorieMax == null ||
        s.valeurCategorieMax! <= 0)
      return;
    final iconMap = {
      'Transport': '🚗',
      'Alimentation': '🍽️',
      'Logement': '🏠',
      'Divers': '📦',
      'Services sociétaux': '🏛️',
    };
    cards.add(
      StatsCardsEntitie(
        icon: iconMap[s.categoriePlusEmettrice] ?? '📊',
        value: s.valeurCategorieMax! / 1000,
        unit: 't CO₂/an',
        text1: '${s.categoriePlusEmettrice}',
        text2: 'Ton axe d\'amélioration principal',
      ),
    );
  }
}
