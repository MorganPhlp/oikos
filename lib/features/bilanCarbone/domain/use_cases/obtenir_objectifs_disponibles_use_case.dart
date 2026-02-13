import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';

class ObtenirObjectifsDisponiblesUseCase {
  const ObtenirObjectifsDisponiblesUseCase();

  List<ObjectifEntity> call() {
    return [
      ObjectifEntity(
        valeur: 0.7,
        label: 'Je vais tout donner',
        description: '-30% par rapport à maintenant',
        colors: [0xFFE8914A, 0xFFD47A3A],
      ),
      ObjectifEntity(
        valeur: 0.8,
        label: 'Je veux me challenger',
        description: '-20% par rapport à maintenant',
        colors: [0xFFBDEE63, 0xFF65BA74],
      ),
      ObjectifEntity(
        valeur: 0.9,
        label: 'J\'y vais tranquille',
        description: '-10% par rapport à maintenant',
        colors: [0xFF65BA74, 0xFF4A9960],
      ),
    ];
  }
}
