import 'action_entity.dart';

class UserChallengeEntity {
  final ActionEntity action;
  final String frequency; // 'journalier', 'hebdomadaire', 'unique'
  final bool isCompletedToday; // Pour cocher la case

  UserChallengeEntity({
    required this.action,
    required this.frequency,
    this.isCompletedToday = false,
  });
}