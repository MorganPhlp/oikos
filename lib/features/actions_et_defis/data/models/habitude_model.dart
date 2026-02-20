import 'package:oikos/features/actions_et_defis/data/models/action_model.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';

class HabitudeModel extends HabitudeEntity {
  HabitudeModel({
    required super.action,
    required super.dateAjout,
  });

  factory HabitudeModel.fromJson(Map<String, dynamic> json) {
    final actionJson = json['actions'] as Map<String, dynamic>;

    final String dateAjoutStr = json['date_ajout'] as String;

    return HabitudeModel(
      action: ActionModel.fromJson(actionJson),
      dateAjout: DateTime.parse(dateAjoutStr).toLocal(),
    );
  }
}