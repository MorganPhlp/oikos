import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class CalculerProgresUseCase {
  final StreakRepository repository;

  CalculerProgresUseCase(this.repository);

  Future<(int individuel, bool collectif)> call(
    String userId,
    DateTime date,
  ) async {
    final individuel = await repository
        .getNombreActionsQuotidiennesValidesDepuis(userId, date);
    final collectif = await repository.hasCompletedActionCommunautaire(userId);

    return (individuel, collectif);
  }
}
