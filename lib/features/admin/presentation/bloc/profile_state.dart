import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/models.dart';

/// Statut d'une opération de sauvegarde pour une section du profil.
enum SectionStatus { idle, loading, success, failure }

abstract class ProfileState {}

/// État initial avant que [ProfileInitEvent] soit dispatché.
class ProfileInitial extends ProfileState {}

/// État chargé : contient les données courantes et les statuts de chaque section.
class ProfileLoaded extends ProfileState {
  final Utilisateurs user;
  final Company company;

  final SectionStatus profileStatus;
  final SectionStatus companyStatus;
  final SectionStatus passwordStatus;

  final String? profileError;
  final String? companyError;
  final String? passwordError;

  /// Avatars disponibles (null = pas encore chargés)
  final List<String>? availableAvatars;

  /// Logos disponibles (null = pas encore chargés)
  final List<String>? availableLogos;

  final bool isLoadingAvatars;
  final bool isLoadingLogos;

  ProfileLoaded({
    required this.user,
    required this.company,
    this.profileStatus = SectionStatus.idle,
    this.companyStatus = SectionStatus.idle,
    this.passwordStatus = SectionStatus.idle,
    this.profileError,
    this.companyError,
    this.passwordError,
    this.availableAvatars,
    this.availableLogos,
    this.isLoadingAvatars = false,
    this.isLoadingLogos = false,
  });

  ProfileLoaded copyWith({
    Utilisateurs? user,
    Company? company,
    SectionStatus? profileStatus,
    SectionStatus? companyStatus,
    SectionStatus? passwordStatus,
    String? profileError,
    String? companyError,
    String? passwordError,
    bool clearProfileError = false,
    bool clearCompanyError = false,
    bool clearPasswordError = false,
    List<String>? availableAvatars,
    List<String>? availableLogos,
    bool? isLoadingAvatars,
    bool? isLoadingLogos,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      company: company ?? this.company,
      profileStatus: profileStatus ?? this.profileStatus,
      companyStatus: companyStatus ?? this.companyStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      profileError: clearProfileError
          ? null
          : (profileError ?? this.profileError),
      companyError: clearCompanyError
          ? null
          : (companyError ?? this.companyError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
      availableAvatars: availableAvatars ?? this.availableAvatars,
      availableLogos: availableLogos ?? this.availableLogos,
      isLoadingAvatars: isLoadingAvatars ?? this.isLoadingAvatars,
      isLoadingLogos: isLoadingLogos ?? this.isLoadingLogos,
    );
  }
}
