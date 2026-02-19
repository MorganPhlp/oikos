import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';

import 'action_model.dart';

class UserActiveActionModel extends UserActiveActionEntity {
  UserActiveActionModel({
    required super.action,
    required super.streakCount,
    super.lastCompletedAt,
  });

  factory UserActiveActionModel.fromJson(Map<String, dynamic> json) {
    final actionJson = json['actions'] as Map<String, dynamic>;

    final String? lastDateStr = json['derniere_realisation'];

    return UserActiveActionModel(
      action: ActionModel.fromJson(actionJson),
      streakCount: json['streak_actuel'] ?? 0,
      lastCompletedAt: lastDateStr != null
          ? DateTime.parse(lastDateStr).toLocal()
          : null,
    );
  }
}
