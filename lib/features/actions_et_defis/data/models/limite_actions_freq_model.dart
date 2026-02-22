import 'package:oikos/features/actions_et_defis/domain/entities/limite_action_freq_entity.dart';

class LimiteActionFreqModel extends LimiteActionFreqEntity {
  LimiteActionFreqModel({required super.frequence, required super.value});

  factory LimiteActionFreqModel.fromJson(Map<String, dynamic> json) {
    final frequence = json['frequence'];
    final value = json['nombre'];

    return LimiteActionFreqModel(frequence: frequence, value: value);
  }
}
