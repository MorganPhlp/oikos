import 'package:equatable/equatable.dart';
import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';

abstract class ResultatState extends Equatable {
  const ResultatState();
  @override
  List<Object?> get props => [];
}

class ResultatInitial extends ResultatState {}

class ResultatLoading extends ResultatState {}

class ResultatError extends ResultatState {
  final String message;
  const ResultatError(this.message);
}

// État : Choix des catégories d'approfondissement
class ResultatChoixCategories extends ResultatState {
  final List<CategorieEmpreinteEntity> categories;
  const ResultatChoixCategories(this.categories);
}

// État : Choix de l'objectif de réduction
class ResultatChoixObjectifs extends ResultatState {
  final double scoreActuel;
  final List<ObjectifEntity> objectifs;
  const ResultatChoixObjectifs({
    required this.scoreActuel,
    required this.objectifs,
  });
}

// État : Affichage final des résultats
class ResultatFinal extends ResultatState {
  final double scoreTotal;
  final DetailBilanEntity scoresParCategorie;
  final List<CarboneEquivalentEntity> equivalents;

  const ResultatFinal({
    required this.scoreTotal,
    required this.scoresParCategorie,
    required this.equivalents,
  });
}
