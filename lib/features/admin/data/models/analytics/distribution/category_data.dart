import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_data.freezed.dart';
part 'category_data.g.dart';

/// Convertisseur pour sérialiser Flutter Color
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.toARGB32();
}

@freezed
sealed class CategoryData with _$CategoryData {
  const factory CategoryData({
    required String name,
    required double percentage,
    required double co2,
    @ColorConverter() required Color color,
  }) = _CategoryData;
  factory CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);
}
