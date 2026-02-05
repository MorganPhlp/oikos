import 'package:equatable/equatable.dart';
import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';

abstract class ResultatEvent extends Equatable {
  const ResultatEvent();
  @override
  List<Object?> get props => [];
}

class DemarrerAnalyseEvent extends ResultatEvent {}

class ValiderCategoriesEvent extends ResultatEvent {
  final List<CategorieEmpreinteEntity> categories;
  const ValiderCategoriesEvent(this.categories);
}

class ValiderObjectifEvent extends ResultatEvent {
  final ObjectifEntity objectif;
  const ValiderObjectifEvent(this.objectif);
}

class RetourAuChoixCategoriesEvent extends ResultatEvent {}
