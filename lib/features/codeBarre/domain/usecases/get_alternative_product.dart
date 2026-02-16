import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/aliment_entity.dart';
import '../repositories/aliment_repository.dart';

class GetAlternativeProduct implements UseCase<AlimentEntity?, AlimentEntity> {
  final AlimentRepository repository;

  GetAlternativeProduct(this.repository);

  @override
  Future<Either<Failure, AlimentEntity?>> call(AlimentEntity produitScanne) async {
    // Si Eco-Score est déjà 'A' (ou 'a'), pas besoin d'alternative
    final currentScore = produitScanne.ecoScore?.toLowerCase();
    if (currentScore == 'a') {
      return const Right(null);
    }

    // A-t-on des catégories pour chercher ?
    if (produitScanne.categoriesTags == null || produitScanne.categoriesTags!.isEmpty) {
      return const Right(null);
    }

    // On prend la catégorie la plus spécifique
    // Dans OpenFoodFacts, les tags sont souvent ordonnés du général au spécifique.
    // On essaie de prendre le dernier élément de la liste.
    final targetCategory = produitScanne.categoriesTags!.last;

    // Appel au repository
    return await repository.getAlternativeProduct(targetCategory);
  }
}