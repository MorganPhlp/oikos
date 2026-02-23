abstract class CarbonStatsEvent {}

class CarbonFootPrintfetched extends CarbonStatsEvent {
  String companyId;

  CarbonFootPrintfetched({required this.companyId});
}
