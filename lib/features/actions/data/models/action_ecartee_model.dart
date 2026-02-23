import 'package:oikos/features/actions/domain/entities/action_ecartee_entity.dart';

class ActionEcarteeModel extends ActionEcarteeEntity {
  ActionEcarteeModel({required super.id});

  factory ActionEcarteeModel.fromJson(Map<String, dynamic> json) {
    return ActionEcarteeModel(id: json['action_id']);
  }

  Map<String, dynamic> toJson() {
    return {'action_id': id};
  }
}
