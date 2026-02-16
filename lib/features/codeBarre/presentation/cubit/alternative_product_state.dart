import '../../domain/entities/aliment_entity.dart';

/*
* Classe permettant de représenter les différents états possibles lors de la recherche d'une alternative à un produit scanné.
* - Initial : état de départ, avant toute action.
* - Loading : en cours de recherche d'une alternative.
* - Success : une alternative a été trouvée, contient l'aliment alternatif.
* - NotFound : aucune alternative n'a été trouvée (ou le produit est déjà A
* - Error : une erreur est survenue lors de la recherche, contient un message d'erreur.
*
* */

sealed class AlternativeProductState {}

final class AlternativeProductInitial extends AlternativeProductState {}

final class AlternativeProductLoading extends AlternativeProductState {}

final class AlternativeProductSuccess extends AlternativeProductState {
  final AlimentEntity alternative;
  AlternativeProductSuccess(this.alternative);
}

// État si aucune alternative n'est trouvée (ou si le produit est déjà A)
final class AlternativeProductNotFound extends AlternativeProductState {}

final class AlternativeProductError extends AlternativeProductState {
  final String message;
  AlternativeProductError(this.message);
}