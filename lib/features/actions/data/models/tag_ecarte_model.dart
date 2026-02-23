import 'package:oikos/features/actions/domain/entities/tag_ecarte_entity.dart';

class TagEcarteModel extends TagEcarteEntity {
  TagEcarteModel({required super.nom});

  factory TagEcarteModel.fromJson(Map<String, dynamic> json) {
    return TagEcarteModel(nom: json['tag_nom']);
  }

  Map<String, dynamic> toJson() {
    return {'tag_nom': nom};
  }
}
