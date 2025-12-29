import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/carbone_equivalent_repository.dart';

class RecupererEquivalentsCarboneUseCase {
  final CarboneEquivalentRepository carboneEquivalentRepository;

  RecupererEquivalentsCarboneUseCase({
    required this.carboneEquivalentRepository,
  });

  Future<List<CarboneEquivalentEntity>> call() async {
    return await carboneEquivalentRepository.fetchAllEquivalents();
  }
}