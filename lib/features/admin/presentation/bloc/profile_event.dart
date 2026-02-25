import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/features/admin/data/models/models.dart';

abstract class ProfileEvent {}

/// Initialise le bloc avec l'utilisateur et l'entreprise courants.
/// Dispatché dans `initState` de [ProfilPage].
class ProfileInitEvent extends ProfileEvent {
  final User user;
  final Company company;
  ProfileInitEvent({required this.user, required this.company});
}

/// Sauvegarde les informations du profil (pseudo, email).
class ProfileUpdateUser extends ProfileEvent {
  final User user;
  ProfileUpdateUser({required this.user});
}

/// Sauvegarde les informations de l'entreprise (nom, domaine email).
class ProfileUpdateCompany extends ProfileEvent {
  final Company company;
  ProfileUpdateCompany({required this.company});
}

/// Déclenche le changement de mot de passe (mock — ne fait rien côté repo).
class ProfileChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  ProfileChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}

/// Remet le statut d'une section à [SectionStatus.idle] après
/// l'affichage du feedback (snackbar succès ou erreur).
class ProfileResetStatus extends ProfileEvent {
  final ProfileSection section;
  ProfileResetStatus({required this.section});
}

/// Charge la liste des avatars disponibles (bucket 'avatars').
class ProfileFetchAvatars extends ProfileEvent {}

/// Charge la liste des logos disponibles (bucket 'logos').
class ProfileFetchLogos extends ProfileEvent {
  final String companyName;
  ProfileFetchLogos({required this.companyName});
}

/// Met à jour l'avatar de l'administrateur.
class ProfileUpdateAvatar extends ProfileEvent {
  final String avatarUrl;
  ProfileUpdateAvatar({required this.avatarUrl});
}

/// Met à jour le logo de l'entreprise.
class ProfileUpdateCompanyLogo extends ProfileEvent {
  final String logoUrl;
  ProfileUpdateCompanyLogo({required this.logoUrl});
}

enum ProfileSection { profile, company, password }
