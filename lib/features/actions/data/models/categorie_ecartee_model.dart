import 'package:oikos/features/actions/domain/entities/categorie_ecartee_entity.dart';

class CategorieEcarteeModel extends CategorieEcarteeEntity {
  CategorieEcarteeModel({required super.nom});

  factory CategorieEcarteeModel.fromJson(Map<String, dynamic> json) {
    return CategorieEcarteeModel(nom: json['categorie_nom']);
  }

  Map<String, dynamic> toJson() {
    return {'categorie_nom': nom};
  }
}
