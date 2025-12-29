import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:ui';

part 'objectif_entity.freezed.dart';
part 'objectif_entity.g.dart';

@freezed
sealed class ObjectifEntity with _$ObjectifEntity {
  const factory ObjectifEntity({
    required double valeur,
    required String label,
    required String description,
    required List<int> colors, // Stockés comme [ARGB, ARGB]
  }) = _ObjectifEntity;

  factory ObjectifEntity.fromJson(Map<String, dynamic> json) =>
      _$ObjectifEntityFromJson(json);
}

extension ObjectifColors on ObjectifEntity {
  List<Color> get gradientColors => colors.map((c) => Color(c)).toList();
}
