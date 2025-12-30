class ReponseUtilisateurEntity {
  final int? id;
  final int bilanId;
  final int questionId;
  final dynamic valeur;

  const ReponseUtilisateurEntity({
    this.id,
    required this.bilanId,
    required this.questionId,
    this.valeur,
  });

  bool get isNumeric => valeur is num;
  double? get asDouble => (valeur as num?)?.toDouble();
}