import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';
part 'detail_bilan_model.freezed.dart';
part 'detail_bilan_model.g.dart';

@freezed
sealed class DetailBilanModel with _$DetailBilanModel {
  const DetailBilanModel._();

  const factory DetailBilanModel({
    @Default(0) int id,
    @Default(0.0) double transport,
    @Default(0.0) double alimentation,
    @Default(0.0) double logement,
    @Default(0.0) double divers,
    @JsonKey(name: 'services_societaux') @Default(0.0) double servicesSocietaux,
  }) = _DetailBilanModel;

  factory DetailBilanModel.fromJson(Map<String, dynamic> json) =>
      _$DetailBilanModelFromJson(json);

  factory DetailBilanModel.fromEntity(DetailBilanEntity entity) {
    return DetailBilanModel(
      id: entity.id,
      transport: entity.transport,
      alimentation: entity.alimentation,
      logement: entity.logement,
      divers: entity.divers,
      servicesSocietaux: entity.servicesSocietaux,
    );
  }
  DetailBilanEntity toEntity() {
    return DetailBilanEntity(
      id: id,
      transport: transport,
      alimentation: alimentation,
      logement: logement,
      divers: divers,
      servicesSocietaux: servicesSocietaux,
    );
  }
}
