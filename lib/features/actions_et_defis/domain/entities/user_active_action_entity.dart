import 'action_entity.dart';

class UserActiveActionEntity {
  final ActionEntity action;
  final int streakCount;
  final DateTime? lastCompletedAt;
  final bool isModeDeVie;

  UserActiveActionEntity({
    required this.action,
    required this.streakCount,
    this.lastCompletedAt,
    this.isModeDeVie = false,
  });

  bool isPromotable() {
    switch (action.frequency.toLowerCase()) {
      case 'quotidienne':
        return streakCount >= 7;
      case 'hebdomadaire':
        return streakCount >= 4;
      case 'mensuelle':
        return streakCount >= 3;
      case 'bonus':
        return streakCount >= 1;
      default:
        return false;
    }
  }

  bool get isCompletedForPeriod {
    if (lastCompletedAt == null) return false;

    final now = DateTime.now();
    final last = lastCompletedAt!.toLocal();

    switch (action.frequency.toLowerCase()) {
      case 'quotidienne':
        return last.year == now.year &&
            last.month == now.month &&
            last.day == now.day;

      case 'hebdomadaire':
        return _isSameIsoWeek(last, now);

      case 'mensuelle':
        return last.year == now.year && last.month == now.month;

      default:
        return false;
    }
  }

  bool _isSameIsoWeek(DateTime date1, DateTime date2) {
    final monday1 = date1.subtract(Duration(days: date1.weekday - 1));
    final monday2 = date2.subtract(Duration(days: date2.weekday - 1));

    return monday1.year == monday2.year &&
        monday1.month == monday2.month &&
        monday1.day == monday2.day;
  }

  UserActiveActionEntity copyWith({
    ActionEntity? action,
    int? streakCount,
    DateTime? lastCompletedAt,
    bool? isModeDeVie,
  }) {
    return UserActiveActionEntity(
      action: action ?? this.action,
      streakCount: streakCount ?? this.streakCount,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      isModeDeVie: isModeDeVie ?? this.isModeDeVie,
    );
  }
}
