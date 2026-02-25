import 'package:freezed_annotation/freezed_annotation.dart';

part 'carbon_foot_print.freezed.dart';
part 'carbon_foot_print.g.dart';


@freezed
sealed class CarbonFootPrint with _$CarbonFootPrint {
  const factory CarbonFootPrint({
    @JsonKey(name:'utilisateur_id')
    required String userId,
    @JsonKey(name:'scoretotalco2ean')
    required double score,
    @JsonKey(name:'date_bilan')
    required String dateBilan,

    // @JsonKey(name:"complet") required bool completed ; 

  }) = _CarbonFootPrint;

  factory CarbonFootPrint.fromJson(Map<String, Object?> json) =>
      _$CarbonFootPrintFromJson(json);
}

