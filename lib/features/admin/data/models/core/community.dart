import 'package:freezed_annotation/freezed_annotation.dart';

part 'community.freezed.dart';
part 'community.g.dart';

@freezed
sealed class Community with _$Community {
  const factory Community({
    required String code,
    @JsonKey(name: 'nom') required String name,
    @JsonKey(name: 'entreprise_id') required String companyId,
    required String description,
    @JsonKey(name: 'nombre_membres') @Default(0) int? membersCount,
    @JsonKey(name: 'bilan_moyen') @Default(0) double? avgScore,
  }) = _Community;

  factory Community.fromJson(Map<String, dynamic> json) => _$CommunityFromJson(json);
}
