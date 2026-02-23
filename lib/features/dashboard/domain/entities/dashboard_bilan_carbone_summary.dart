import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';

class DashboardBilanCarboneSummary {
  final double scoreTotalKg;
  final DetailBilanEntity detail;

  const DashboardBilanCarboneSummary({
    required this.scoreTotalKg,
    required this.detail,
  });
}
