import 'package:oikos/features/admin/domain/entities/company.dart';

class CompanyModel extends Company {
  CompanyModel({
    required super.id,
    required super.logoUrl,
    required super.name,
  });

  /// Transforme le JSON de Supabase (ou de ta vue SQL) en CompanyModel
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String,
    );
  }

  /// Transforme l'objet en Map pour l'envoyer à Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name, 
      'logo_url':logoUrl,
    };
  }

}
