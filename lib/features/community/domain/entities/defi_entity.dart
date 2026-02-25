import 'package:equatable/equatable.dart';
import 'package:oikos/core/secrets/app_secrets.dart';
import 'package:oikos/features/actions/domain/entities/action_entity.dart';

class DefiEntity extends Equatable {
  final String id;
  final String status;
  final String categorieNom;
  final String communauteDemandeurCode;
  final String communauteCibleCode;
  final DateTime dateFin;
  final String? titrePersonnalise;

  // L'objet Action regroupé
  final ActionEntity? action;

  // Stats de Vote
  final int votesOui1;
  final int votesNon1;
  final int votesOui2;
  final int votesNon2;

  // Stats de Participation
  final int participantsCommu1;
  final int participantsCommu2;

  // Totaux des membres
  final int totalMembers1;
  final int totalMembers2;

  // Noms des communautés
  final String nomCommu1;
  final String nomCommu2;

  //logos
  final String? logoCommu1;
  final String? logoCommu2;

  const DefiEntity({
    required this.id,
    required this.status,
    required this.categorieNom,
    required this.communauteDemandeurCode,
    required this.communauteCibleCode,
    required this.dateFin,
    required this.nomCommu1,
    required this.nomCommu2,
    this.action, // Passé via DefiModel.fromJson
    this.titrePersonnalise,
    this.votesOui1 = 0,
    this.votesNon1 = 0,
    this.votesOui2 = 0,
    this.votesNon2 = 0,
    this.participantsCommu1 = 0,
    this.participantsCommu2 = 0,
    this.totalMembers1 = 0,
    this.totalMembers2 = 0,
    this.logoCommu1,
    this.logoCommu2,
  });

  /// Titre intelligent : priorité au titre personnalisé, puis titre de l'action
  String get displayTitle => titrePersonnalise ?? action?.title ?? 'Défi';

  /// Indique si on est en phase de vote
  bool get isVotePhase => status == 'VOTE_LANCEMENT';

  /// Calcul de progression générique pour la Communauté 1 (Demandeur)
  double get progress1 {
    if (totalMembers1 <= 0) return 0.0;
    final current = isVotePhase ? votesOui1 : participantsCommu1;
    // Objectif : 60% des membres
    return (current / (totalMembers1)).clamp(0.0, 1.0);
  }

  /// Calcul de progression générique pour la Communauté 2 (Cible)
  double get progress2 {
    if (totalMembers2 <= 0) return 0.0;
    final current = isVotePhase ? votesOui2 : participantsCommu2;
    return (current / totalMembers2.clamp(0.0, 1.0));
  }

  /// Temps restant en format lisible
  String get remainingTime {
    final now = DateTime.now();
    final difference = dateFin.difference(now);
    if (difference.isNegative) return "Terminé";
    if (difference.inDays > 0) return "${difference.inDays}j restants";
    return "${difference.inHours}h restantes";
  }

  @override
  List<Object?> get props => [
    id,
    status,
    action,
    votesOui1,
    votesOui2,
    participantsCommu1,
    participantsCommu2,
    totalMembers1,
    totalMembers2,
  ];
}

extension DefiListFilter on List<DefiEntity> {
  List<DefiEntity> get pendingDefis =>
      where((defi) => defi.isVotePhase).toList();

  List<DefiEntity> get activeDefis =>
      where((defi) => defi.status == 'ACTIF').toList();
}

extension DefiAssets on DefiEntity {
  static const _storagePath =
      '${AppSecrets.supabaseUrl}/storage/v1/object/public/logos';

  String get logoUrl1 => '$_storagePath/$logoCommu1.png';
  String get logoUrl2 => '$_storagePath/$logoCommu2.png';
}
