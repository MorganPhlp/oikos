class DetailBilanEntity {
  final int id;
  final double transport;
  final double alimentation;
  final double logement;
  final double divers;
  final double servicesSocietaux;

  DetailBilanEntity({
    required this.id,
    required this.transport,
    required this.alimentation,
    required this.logement,
    required this.divers,
    required this.servicesSocietaux,
  });

  factory DetailBilanEntity.empty() {
    return DetailBilanEntity(
      id: 0,
      transport: 0,
      alimentation: 0,
      logement: 0,
      divers: 0,
      servicesSocietaux: 0,
    );
  }

  Map<String, double> toMap() {
    return {
      'Transport': transport,
      'Alimentation': alimentation,
      'Logement': logement,
      'Divers': divers,
      'Services Sociétaux': servicesSocietaux,
    };
  }
}
