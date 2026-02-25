import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';

class ParticipationDefiModel extends ParticipationDefiEntity {
  const ParticipationDefiModel({
    required super.defiId,
    required super.hasParticipated,
  });

  factory ParticipationDefiModel.fromJson(Map<String, dynamic> json) {
    return ParticipationDefiModel(
      defiId: json['defi_id']!.toString(),
      hasParticipated: json['has_participated'] as bool,
    );
  }
}
