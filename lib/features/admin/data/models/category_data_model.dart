import 'package:oikos/features/admin/domain/entities/category_data.dart';
import 'package:oikos/core/utils/utils.dart';

class CategoryDataModel extends CategoryData {
  CategoryDataModel({
    required super.co2,
    required super.name,
    required super.percentage,
    required super.color,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'co2': co2, 'percentage': percentage};
  }

  factory CategoryDataModel.fromJson(Map<String, dynamic> json) {
    return CategoryDataModel(
      name: json['name'],
      co2: json['co2'],
      percentage: json['percentage'],
      color: hexToColor(json['color']),
    );
  }
}
