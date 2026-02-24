import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/utils/utils.dart';

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
    @JsonKey(name: 'logo_url')  String? logoUrl,
    @JsonKey(name:'couleurhex') String? colorHex,
  }) = _Community;

  factory Community.fromJson(Map<String, dynamic> json) => _$CommunityFromJson(json);
}

extension CommunityExtension on Community {
  String get logoFullUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? (logoUrl!.startsWith('http')
          ? logoUrl!
          : StorageUtils.getPublicUrl('avatars', logoUrl!))
      : 'https://ui-avatars.com/api/?name=$name&background=random';
}
