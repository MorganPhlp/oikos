import 'package:flutter_js/quickjs/ffi.dart';
import 'package:oikos/features/actions/domain/entities/action_entity.dart';
import 'package:oikos/features/actions/domain/entities/user_active_action_entity.dart';

class LimiteActionFreqEntity {
  String frequence;
  int? value;

  LimiteActionFreqEntity({required this.frequence, required this.value});
}

extension ActionLimitChecker on List<UserActiveActionEntity> {
  bool isLimitReached(
    List<LimiteActionFreqEntity> limits,
    ActionEntity action,
  ) {
    // .firstWhereOrNull est beaucoup plus flexible sur les types
    final actionLimit = limits.firstWhereOrNull(
      (limit) => limit.frequence == action.frequency,
    );

    // Si pas de limite trouvée ou valeur null, on ne bloque pas
    if (actionLimit == null || actionLimit.value == null) return false;

    final count = where(
      (entry) => entry.action.frequency == action.frequency,
    ).length;

    return count >= actionLimit.value!;
  }
}
