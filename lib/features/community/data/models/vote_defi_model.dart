import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';

class VoteDefiModel extends VoteDefiEntity {
  const VoteDefiModel({required super.defiId, required super.voteValue});

  factory VoteDefiModel.fromJson(Map<String, dynamic> json) {
    return VoteDefiModel(
      defiId: json['defi_id']!.toString(),
      voteValue: json['est_favorable'] as bool,
    );
  }
}
