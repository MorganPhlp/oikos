part of 'bilan_bloc.dart';



abstract class BilanEvent extends Equatable {
  const BilanEvent();

  @override
  List<Object?> get props => [];
}

class DemarrerBilanEvent extends BilanEvent {}

class RepondreQuestionEvent extends BilanEvent {
  final dynamic valeur;

  const RepondreQuestionEvent(this.valeur);

  @override
  List<Object?> get props => [valeur];
}

class RevenirQuestionPrecedenteEvent extends BilanEvent {}

class RetourVersQuestionsFromObjectifsEvent extends BilanEvent {}

class RetourVersChoixCategoriesFromObjectifsEvent extends BilanEvent {}

class SelectionnerCategoriesEvent extends BilanEvent {
  final List<CategorieEmpreinteEntity> categories;

  const SelectionnerCategoriesEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}

class PreparerObjectifsEvent extends BilanEvent {}

class ValiderObjectifEvent extends BilanEvent {
  final double objectif;

  const ValiderObjectifEvent(this.objectif);

  @override
  List<Object?> get props => [objectif];
}
