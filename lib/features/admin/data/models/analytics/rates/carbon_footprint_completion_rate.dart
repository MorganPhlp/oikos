import 'package:freezed_annotation/freezed_annotation.dart';

part 'carbon_footprint_completion_rate.freezed.dart';
part 'carbon_footprint_completion_rate.g.dart';

@freezed
sealed class CarbonFootprintCompletionRate with _$CarbonFootprintCompletionRate {

  const CarbonFootprintCompletionRate._();

  const factory CarbonFootprintCompletionRate({
    @JsonKey(name:'completion_percentage')
    required double completionPourcentage,

    @JsonKey(name:'total_utilisateurs')
    required int totalUsers,
    
    @JsonKey(name:'utilisateurs_bilan_termine')
    required int usersWithCompletedBilan
  }) = _CarbonFootprintCompletionRate;


  factory CarbonFootprintCompletionRate.fromJson(Map<String, dynamic> json) =>
      _$CarbonFootprintCompletionRateFromJson(json);


  /// Utilisateurs en attente (non complété)
  int get usersWaiting => totalUsers - usersWithCompletedBilan;

  double get completionPercentage => totalUsers > 0 
      ? (usersWithCompletedBilan / totalUsers) * 100 
      : 0;

}