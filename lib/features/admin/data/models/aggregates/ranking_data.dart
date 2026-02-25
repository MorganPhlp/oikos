import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/core/carbon_foot_print.dart';
import 'package:oikos/features/admin/data/models/models.dart';

part 'ranking_data.freezed.dart';
part 'ranking_data.g.dart';

@freezed
sealed class RankingData with _$RankingData {
  const factory RankingData({
    required List<Utilisateurs> users,
    required List<CarbonFootPrint> carbonFootPrints,
    required List<Community> communities,
  }) = _RankingData;

  factory RankingData.fromJson(Map<String, dynamic> json) =>
      _$RankingDataFromJson(json);
}
