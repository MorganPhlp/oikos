import 'package:oikos/features/actions/data/models/action_model.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';

class DefiModel extends DefiEntity {
  final bool hasVoted;
  final bool? userVoteChoice;
  final bool isJoined;

  const DefiModel({
    required super.id,
    required super.status,
    required super.categorieNom,
    required super.communauteDemandeurCode,
    required super.communauteCibleCode,
    required super.dateFin,
    required super.nomCommu1,
    required super.nomCommu2,
    required this.hasVoted,
    required this.isJoined,
    this.userVoteChoice,
    super.titrePersonnalise,
    super.action, // <-- Ajoute bien cette ligne ici
    super.votesOui1,
    super.votesNon1,
    super.votesOui2,
    super.votesNon2,
    super.participantsCommu1,
    super.participantsCommu2,
    super.totalMembers1,
    super.totalMembers2,
    super.logoCommu1,
    super.logoCommu2,
  });

  factory DefiModel.fromJson(Map<String, dynamic> json, {ActionModel? action}) {
    // 1. Calcul des états utilisateurs
    final userVotes = json['user_vote'] as List?;
    final userParts = json['user_participation'] as List?;

    final bool calculatedHasVoted = userVotes != null && userVotes.isNotEmpty;
    final bool calculatedIsJoined = userParts != null && userParts.isNotEmpty;

    bool? voteChoice;
    if (calculatedHasVoted && userVotes!.first is Map) {
      voteChoice = userVotes.first['est_favorable'] as bool?;
    }

    // 2. On récupère l'action soit du paramètre (injection manuelle),
    // soit du JSON (si la jointure fonctionne)
    final ActionModel? finalAction =
        action ??
        (json['action'] != null ? ActionModel.fromJson(json['action']) : null);

    return DefiModel(
      id: json['defi_id']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      categorieNom: json['categorie_nom']?.toString() ?? '',
      communauteDemandeurCode:
          json['communaute_demandeur_code']?.toString() ?? '',
      communauteCibleCode: json['communaute_cible_code']?.toString() ?? '',
      nomCommu1: json['nom_commu1']?.toString() ?? '',
      nomCommu2: json['nom_commu2']?.toString() ?? '',
      dateFin: DateTime.parse(json['date_fin'] as String),

      hasVoted: calculatedHasVoted,
      isJoined: calculatedIsJoined,
      userVoteChoice: voteChoice,
      titrePersonnalise: json['titre_personnalise']?.toString(),

      // Injection du paramètre
      action: finalAction,

      // Stats
      votesOui1: (json['votes_oui_commu1'] as num?)?.toInt() ?? 0,
      votesNon1: (json['votes_non_commu1'] as num?)?.toInt() ?? 0,
      votesOui2: (json['votes_oui_commu2'] as num?)?.toInt() ?? 0,
      votesNon2: (json['votes_non_commu2'] as num?)?.toInt() ?? 0,
      participantsCommu1: (json['participants_commu1'] as num?)?.toInt() ?? 0,
      participantsCommu2: (json['participants_commu2'] as num?)?.toInt() ?? 0,
      totalMembers1: (json['membres_total_commu1'] as num?)?.toInt() ?? 0,
      totalMembers2: (json['membres_total_commu2'] as num?)?.toInt() ?? 0,
      logoCommu1: json['logo_commu1']?.toString(),
      logoCommu2: json['logo_commu2']?.toString(),
    );
  }
}
