import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/utils/utils.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
sealed class Company with _$Company {
  const factory Company({
    required String id,

    @JsonKey(name: 'nom') required String name,

    @JsonKey(name: 'logo_url') required String? logoUrl,

    @JsonKey(name: 'domaine_email') required String domainEmail,

    required String description,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}

extension CompanyExtension on Company {

   String get logoNetworkUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? StorageUtils.getNetworkUrl('logos', logoUrl!)
      : 'https://ui-avatars.com/api/?name=$name&background=random';

  String get logoLocalUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? StorageUtils.getLocalUrl('logos', logoUrl!)
      : 'https://ui-avatars.com/api/?name=$name&background=random';
}
