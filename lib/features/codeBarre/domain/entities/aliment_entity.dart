import 'package:equatable/equatable.dart';

class AlimentEntity extends Equatable {
  final String codeBarre;
  final String nom;
  final String? marque;
  final double? quantite; // Poids en grammes ou volume en ml
  final String? ecoScore; // A, B, C, D, E (Score carbone)
  final String? nutriScore; // A, B, C, D, E
  final String? ingredients; // Liste simple pour info
  final String? imageUrl; // Pour afficher la photo du produit
  final List<String>? categoriesTags; //Notamment pour faire des recommendation sur un produit similaire

  const AlimentEntity({
    required this.codeBarre,
    required this.nom,
    this.marque,
    this.quantite,
    this.ecoScore,
    this.nutriScore,
    this.ingredients,
    this.imageUrl,
    this.categoriesTags,
  });

  @override
  List<Object?> get props => [
    codeBarre,
    nom,
    marque,
    quantite,
    ecoScore,
    nutriScore,
    ingredients,
    imageUrl,
  ];
}