import 'package:equatable/equatable.dart';

class CommunityEntity extends Equatable {
  final String code;
  final String nom;
  final String? entrepriseId;
  final String? description;
  final String couleurHEX;
  final int plantXp;
  final double totalCarbonSaved;
  final String? logoUrl;
  final int membersCount;

  const CommunityEntity({
    required this.code,
    required this.nom,
    this.entrepriseId,
    this.description,
    required this.couleurHEX,
    this.plantXp = 0,
    this.totalCarbonSaved = 0.0,
    this.logoUrl,
    this.membersCount = 0,
  });

  @override
  List<Object?> get props => [
    code,
    nom,
    entrepriseId,
    description,
    couleurHEX,
    plantXp,
    totalCarbonSaved,
    logoUrl,
    membersCount,
  ];
}
