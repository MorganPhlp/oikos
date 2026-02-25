import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart'
    show SectionStatus;
import 'package:oikos/features/admin/presentation/pages/community_management_page.dart';

export 'package:oikos/features/admin/presentation/bloc/profile_state.dart'
    show SectionStatus;

abstract class CommunityState {}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final CommunityData data;

  /// Statut de l'opération en cours (création, modification, suppression…)
  final SectionStatus operationStatus;

  /// Message d'erreur de l'opération (null si pas d'erreur)
  final String? operationError;

  /// Message de succès de l'opération (null si pas de succès)
  final String? successMessage;

  /// Vue mobile actuelle
  final MobileView currentMobileView;

  /// Communauté sélectionnée (pour les actions)
  final Community? selectedCommunity;
  final List<Utilisateurs>? selectedUsers;

  /// Utilisateur sélectionné (pour les actions)
  final Utilisateurs? selectedUser;

  /// Nouvelle communauté sélectionnée (pour le changement de communauté)
  final String? selectedNewCommunityId;
  final String? selectedCompanyId;

  /// Logos disponibles depuis le storage (null = pas encore chargés)
  final List<String>? availableLogos;
  final bool isLoadingLogos;

  CommunityLoaded({
    required this.data,
    this.operationStatus = SectionStatus.idle,
    this.operationError,
    this.successMessage,
    this.currentMobileView = MobileView.list,
    this.selectedCommunity,
    this.selectedUser,
    this.selectedUsers,
    this.selectedNewCommunityId,
    this.selectedCompanyId,
    this.availableLogos,
    this.isLoadingLogos = false,
  });

  CommunityLoaded copyWith({
    CommunityData? data,
    SectionStatus? operationStatus,
    String? operationError,
    String? successMessage,
    bool clearOperationError = false,
    bool clearSuccessMessage = false,
    MobileView? currentMobileView,
    Community? selectedCommunity,
    Utilisateurs? selectedUser,
    List<Utilisateurs>? selectedUsers,
    String? selectedNewCommunityId,
    String? selectedCompanyId,
    List<String>? availableLogos,
    bool? isLoadingLogos,
  }) {
    return CommunityLoaded(
      data: data ?? this.data,
      operationStatus: operationStatus ?? this.operationStatus,
      operationError: clearOperationError
          ? null
          : (operationError ?? this.operationError),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      currentMobileView: currentMobileView ?? this.currentMobileView,
      selectedCommunity: selectedCommunity ?? this.selectedCommunity,
      selectedUser: selectedUser ?? this.selectedUser,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      selectedNewCommunityId:
          selectedNewCommunityId ?? this.selectedNewCommunityId,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      availableLogos: availableLogos ?? this.availableLogos,
      isLoadingLogos: isLoadingLogos ?? this.isLoadingLogos,
    );
  }
}

class CommunityFetchingError extends CommunityState {
  final String message;
  CommunityFetchingError({required this.message});
}
