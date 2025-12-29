import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';

abstract class CarboneEquivalentRepository {
  Future<List<CarboneEquivalentEntity>> fetchAllEquivalents();
}