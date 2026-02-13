import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';

abstract class BilanSessionRepository {
  Future<int> getBilanId(String userId);
  Future<void> createNewBilanSession(String userId);
  Future<void> setBilanScore(String userId, double score);
  Future<bool> hasBilanEnCours(String userId);
  Future<void> deleteBilan(String userId);

  Future<void> saveDetailBilan(DetailBilanEntity detailBilan) async {}
}
