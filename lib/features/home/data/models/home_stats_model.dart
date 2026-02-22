import 'package:oikos/features/home/domain/entities/home_stats_entity.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.nbActionsRealisees,
    required super.totalXpGagne,
    required super.impactScoreXp,
    super.nbActionsEnCours,
    super.nbHabitudes,
    super.scoreTotalCo2,
    super.categoriePlusEmettrice,
    super.valeurCategorieMax,
    super.transport,
    super.alimentation,
    super.logement,
    super.divers,
    super.servicesSocietaux,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      nbActionsRealisees: (json['nb_actions_realisees'] as num?)?.toInt() ?? 0,
      totalXpGagne: (json['total_xp_gagne'] as num?)?.toInt() ?? 0,
      impactScoreXp: (json['impact_score_xp'] as num?)?.toInt() ?? 0,
      nbActionsEnCours: (json['nb_actions_en_cours'] as num?)?.toInt() ?? 0,
      nbHabitudes: (json['nb_habitudes'] as num?)?.toInt() ?? 0,
      scoreTotalCo2: (json['score_total_co2'] as num?)?.toDouble(),
      categoriePlusEmettrice: json['categorie_plus_emettrice'] as String?,
      valeurCategorieMax: (json['valeur_categorie_max'] as num?)?.toDouble(),
      transport: (json['transport'] as num?)?.toDouble() ?? 0,
      alimentation: (json['alimentation'] as num?)?.toDouble() ?? 0,
      logement: (json['logement'] as num?)?.toDouble() ?? 0,
      divers: (json['divers'] as num?)?.toDouble() ?? 0,
      servicesSocietaux: (json['services_societaux'] as num?)?.toDouble() ?? 0,
    );
  }
}
