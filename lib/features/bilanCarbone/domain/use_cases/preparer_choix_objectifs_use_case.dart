import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/obtenir_objectifs_disponibles_use_case.dart';

class PreparerChoixObjectifsUseCase {
  final CalculerBilanUseCase calculerBilanUseCase;
  final ObtenirObjectifsDisponiblesUseCase obtenirObjectifsUseCase;

  PreparerChoixObjectifsUseCase({
    required this.calculerBilanUseCase,
    required this.obtenirObjectifsUseCase,
  });

  Future<
    ({
      double scoreActuel,
      DetailBilanEntity detailBilan,
      List<ObjectifEntity> objectifs,
    })
  >
  call() async {
    final (scoreEnKg, detailBilan) = await calculerBilanUseCase.call();
    final objectifs = await obtenirObjectifsUseCase.call();

    return (
      scoreActuel: scoreEnKg,
      detailBilan: detailBilan,
      objectifs: objectifs,
    );
  }
}
