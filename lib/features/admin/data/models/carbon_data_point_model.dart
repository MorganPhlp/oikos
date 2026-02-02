import 'package:oikos/features/admin/domain/entities/carbon_data_point.dart';

class CarbonDataPointModel extends CarbonDataPoint {
  CarbonDataPointModel({required super.period, required super.averageCo2});

  Map<String, dynamic> toJson() {
    return {'period': period, 'average_co2': averageCo2};
  }

  factory CarbonDataPointModel.fromJson(Map<String, dynamic> json) {
    return CarbonDataPointModel(
      period: DateTime.parse(json['period']),
      averageCo2: json['average_co2'],
    );
  }
}
