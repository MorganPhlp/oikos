// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_bilan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DetailBilanModel _$DetailBilanModelFromJson(Map<String, dynamic> json) =>
    _DetailBilanModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      transport: (json['transport'] as num?)?.toDouble() ?? 0.0,
      alimentation: (json['alimentation'] as num?)?.toDouble() ?? 0.0,
      logement: (json['logement'] as num?)?.toDouble() ?? 0.0,
      divers: (json['divers'] as num?)?.toDouble() ?? 0.0,
      servicesSocietaux:
          (json['services_societaux'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$DetailBilanModelToJson(_DetailBilanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transport': instance.transport,
      'alimentation': instance.alimentation,
      'logement': instance.logement,
      'divers': instance.divers,
      'services_societaux': instance.servicesSocietaux,
    };
