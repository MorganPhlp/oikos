import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/domain/entities/user.dart' as u;
import 'package:oikos/core/theme/breakpoints.dart';

abstract class CommunityState {}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final CommunityData data;

  final String? errorMessage;

  /// Vue mobile actuelle
  final MobileView currentMobileView;

  /// Communauté sélectionnée (pour les actions)
  final Community? selectedCommunity;
  final List<u.User>? selectedUsers;

  /// Utilisateur sélectionné (pour les actions)
  final u.User? selectedUser;

  /// Nouvelle communauté sélectionnée (pour le changement de communauté)
  final String? selectedNewCommunityId;
  final String? selectedCompanyId;

  final bool isSubmitting; // Pour afficher un petit loader sur le bouton
  final bool updateSuccess; // Pour déclencher un SnackBar ou fermer une modal

  CommunityLoaded({
    required this.data,
    this.currentMobileView = MobileView.list,
    this.selectedCommunity,
    this.selectedUser,
    this.selectedUsers,
    this.selectedNewCommunityId,
    this.selectedCompanyId,
    this.isSubmitting = false,
    this.updateSuccess = false,
    this.errorMessage
  });

  CommunityLoaded copyWith({
    CommunityData? data,
    MobileView? currentMobileView,
    Community? selectedCommunity,
    u.User? selectedUser,
    List<u.User>? selectedUsers,
    String? selectedNewCommunityId,
    String? selectedCompanyId,
    bool? isSubmitting,
    bool? updateSuccess,
    String? errorMessage
  }) {
    return CommunityLoaded(
      data: data ?? this.data,
      currentMobileView: currentMobileView ?? this.currentMobileView,
      selectedCommunity: selectedCommunity ?? this.selectedCommunity,
      selectedUser: selectedUser ?? this.selectedUser,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      selectedNewCommunityId:
          selectedNewCommunityId ?? this.selectedNewCommunityId,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}

class CommunityFetchingError extends CommunityState {
  final String message;
  CommunityFetchingError({required this.message});
}
