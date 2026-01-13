class CarboneEquivalentEntity {
  final int id;
  final String equivalentLabel;
  final double valeur1Tonne;
  final String? icone;

  const CarboneEquivalentEntity({
    required this.id,
    required this.equivalentLabel,
    required this.valeur1Tonne,
    this.icone,
  });
}