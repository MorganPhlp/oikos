import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';
import 'package:oikos/features/admin/domain/use_cases/delete_community.dart';
import 'package:oikos/features/admin/domain/use_cases/get_logos.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_code.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_logo.dart';
import 'package:oikos/features/admin/domain/use_cases/update_user.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'package:oikos/features/admin/domain/use_cases/get_community_data.dart';

import 'package:oikos/features/admin/presentation/pages/community_management_page.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final GetCommunityData getCommunityData;
  final UpdateCommunityCode updateCommunityCode;
  final UpdateUser updateUser;
  final CreateCommunity createCommunity;
  final DeleteCommunity deleteCommunity;
  final GetLogos getLogos;
  final UpdateCommunityLogo updateCommunityLogo;

  CommunityBloc({
    required this.getCommunityData,
    required this.updateCommunityCode,
    required this.updateUser,
    required this.createCommunity,
    required this.deleteCommunity,
    required this.getLogos,
    required this.updateCommunityLogo,
  }) : super(CommunityInitial()) {
    // --- CHARGEMENT DES DONNÉES ---
    on<CommunityDataFetched>((event, emit) async {
      emit(CommunityLoading());
      final result = await getCommunityData.call(event.companyId);
      result.fold(
        (failure) => emit(CommunityFetchingError(message: failure.message)),
        (data) => emit(CommunityLoaded(data: data)),
      );
    });

    // --- MISE À JOUR DU CODE ---
    on<UpdateCommunityCodeEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final result = await updateCommunityCode.call(
          event.newCode,
          event.communityId,
        );
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedCommunities = currentState.data.communities.map((c) {
              return c.code == event.communityId
                  ? c.copyWith(code: event.newCode)
                  : c;
            }).toList();

            final newData = currentState.data.copyWith(
              communities: updatedCommunities,
            );

            emit(
              CommunityLoaded(
                data: newData,
                operationStatus: SectionStatus.success,
                successMessage: "Code d'accès mis à jour",
              ),
            );
          },
        );
      }
    });

    // --- MISE À JOUR UTILISATEUR ---
    on<UpdateUserEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final result = await updateUser.call(event.user);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedUsers = currentState.data.users.map((user) {
              return user.id == event.user.id ? event.user : user;
            }).toList();

            final newData = currentState.data.copyWith(users: updatedUsers);
            emit(
              CommunityLoaded(
                data: newData,
                operationStatus: SectionStatus.success,
                successMessage: 'Membre mis à jour',
              ),
            );
          },
        );
      }
    });

    on<SelectedCommunityEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        final community = currentState.data.communities[event.index];
        final users = currentState.data.users
            .where((u) => u.codeCommunaute == community.code)
            .toList();
        emit(
          currentState.copyWith(
            selectedCommunity: community,
            selectedUsers: users,
          ),
        );
      }
    });

    // --- REMISE À ZÉRO DU STATUT après affichage du feedback ---
    on<ResetCommunityStatusEvent>((event, emit) {
      if (state is CommunityLoaded) {
        emit(
          (state as CommunityLoaded).copyWith(
            operationStatus: SectionStatus.idle,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );
      }
    });

    // --- CHANGEMENT DE COMMUNAUTÉ D'UN UTILISATEUR ---
    on<ChangeUserCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final user = currentState.data.users.firstWhere(
          (u) => u.id == event.userId,
        );
        final updatedUser = user.copyWith(codeCommunaute: event.newCommunityId);

        final result = await updateUser.call(updatedUser);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedUsers = currentState.data.users.map((u) {
              return u.id == event.userId ? updatedUser : u;
            }).toList();

            final updatedCommunities = currentState.data.communities.map((c) {
              if (c.code == user.codeCommunaute) {
                return c.copyWith(membersCount: (c.membersCount ?? 0) - 1);
              } else if (c.code == event.newCommunityId) {
                return c.copyWith(membersCount: (c.membersCount ?? 0) + 1);
              }
              return c;
            }).toList();

            final newData = currentState.data.copyWith(
              users: updatedUsers,
              communities: updatedCommunities,
            );

            final newSelectedUsers = currentState.selectedCommunity != null
                ? updatedUsers
                      .where(
                        (u) =>
                            u.codeCommunaute ==
                            currentState.selectedCommunity!.code,
                      )
                      .toList()
                : currentState.selectedUsers;

            emit(
              currentState.copyWith(
                data: newData,
                selectedUsers: newSelectedUsers,
                operationStatus: SectionStatus.success,
                successMessage: 'Communauté du membre modifiée',
                clearOperationError: true,
              ),
            );
          },
        );
      }
    });

    // --- SUPPRESSION D'UN UTILISATEUR D'UNE COMMUNAUTÉ ---
    on<RemoveUserFromCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final user = currentState.data.users.firstWhere(
          (u) => u.id == event.userId,
        );
        final oldCommunityId = user.codeCommunaute;
        final updatedUser = user.copyWith(codeCommunaute: '');

        final result = await updateUser.call(updatedUser);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedUsers = currentState.data.users.map((u) {
              return u.id == event.userId ? updatedUser : u;
            }).toList();

            final updatedCommunities = currentState.data.communities.map((c) {
              if (c.code == oldCommunityId) {
                return c.copyWith(membersCount: (c.membersCount ?? 0) - 1);
              }
              return c;
            }).toList();

            final newData = currentState.data.copyWith(
              users: updatedUsers,
              communities: updatedCommunities,
            );

            final newSelectedUsers = currentState.selectedCommunity != null
                ? updatedUsers
                      .where(
                        (u) =>
                            u.codeCommunaute ==
                            currentState.selectedCommunity!.code,
                      )
                      .toList()
                : currentState.selectedUsers;

            emit(
              currentState.copyWith(
                data: newData,
                selectedUsers: newSelectedUsers,
                operationStatus: SectionStatus.success,
                successMessage: 'Membre retiré de la communauté',
                clearOperationError: true,
              ),
            );
          },
        );
      }
    });

    // --- NAVIGATION MOBILE ---
    on<NavigateToMobileViewEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            currentMobileView: event.view,
            selectedCommunity:
                event.community ?? currentState.selectedCommunity,
            selectedUser: event.user ?? currentState.selectedUser,
          ),
        );
      }
    });

    on<GoBackMobileEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        switch (currentState.currentMobileView) {
          case MobileView.members:
            emit(
              currentState.copyWith(
                currentMobileView: MobileView.list,
                selectedCommunity: null,
              ),
            );
            break;
          case MobileView.changeUser:
            emit(
              currentState.copyWith(
                currentMobileView: MobileView.members,
                selectedUser: null,
              ),
            );
            break;
          case MobileView.list:
            break;
        }
      }
    });

    // --- SÉLECTION UTILISATEUR ---
    on<SelectUserEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            selectedUser: event.user,
            selectedNewCommunityId: event.user.codeCommunaute,
          ),
        );
      }
    });

    // --- SÉLECTION NOUVELLE COMMUNAUTÉ ---
    on<SelectNewCommunityEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(selectedNewCommunityId: event.communityId));
      }
    });

    // --- SÉLECTION ENTREPRISE ---
    on<SelectCompanyEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(selectedCompanyId: event.companyId));
      }
    });

    // --- CONFIRMER CHANGEMENT COMMUNAUTÉ ---
    on<ConfirmChangeUserCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        final user = currentState.selectedUser;
        final newCommunityId = currentState.selectedNewCommunityId;

        if (user == null || newCommunityId == null) return;
        if (user.codeCommunaute == newCommunityId) return;

        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final updatedUser = user.copyWith(codeCommunaute: newCommunityId);
        final result = await updateUser.call(updatedUser);

        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedUsers = currentState.data.users.map((u) {
              return u.id == user.id ? updatedUser : u;
            }).toList();

            final updatedCommunities = currentState.data.communities.map((c) {
              if (c.code == user.codeCommunaute) {
                return c.copyWith(membersCount: (c.membersCount ?? 0) - 1);
              } else if (c.code == newCommunityId) {
                return c.copyWith(membersCount: (c.membersCount ?? 0) + 1);
              }
              return c;
            }).toList();

            final newData = currentState.data.copyWith(
              users: updatedUsers,
              communities: updatedCommunities,
            );

            final newSelectedUsers = currentState.selectedCommunity != null
                ? updatedUsers
                      .where(
                        (u) =>
                            u.codeCommunaute ==
                            currentState.selectedCommunity!.code,
                      )
                      .toList()
                : currentState.selectedUsers;

            emit(
              currentState.copyWith(
                data: newData,
                selectedUsers: newSelectedUsers,
                operationStatus: SectionStatus.success,
                successMessage: 'Communauté du membre modifiée',
                clearOperationError: true,
              ),
            );
          },
        );
      }
    });

    on<CreateNewCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final newCommunity = Community(
          code: event.code,
          name: event.name,
          companyId: event.companyId,
          description: '',
          logoUrl: event.logoUrl,
        );

        final result = await createCommunity.call(newCommunity);

        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedCommunites = [
              ...currentState.data.communities,
              newCommunity,
            ];
            final newData = currentState.data.copyWith(
              communities: updatedCommunites,
            );
            emit(
              currentState.copyWith(
                data: newData,
                operationStatus: SectionStatus.success,
                successMessage: 'Communauté créée avec succès',
                clearOperationError: true,
              ),
            );
          },
        );
      }
    });

    // --- SUPPRESSION COMMUNAUTÉ ---
    on<DeleteCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final result = await deleteCommunity.call(event.communityId);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedCommunities = currentState.data.communities
                .where((c) => c.code != event.communityId)
                .toList();

            final newData = currentState.data.copyWith(
              communities: updatedCommunities,
            );

            emit(
              currentState.copyWith(
                data: newData,
                operationStatus: SectionStatus.success,
                successMessage: 'Communauté supprimée',
                clearOperationError: true,
              ),
            );
          },
        );
      }
    });

    // --- CHARGEMENT DES LOGOS DISPONIBLES ---
    on<FetchLogosEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isLoadingLogos: true));
        final result = await getLogos.getAvatars();
        result.fold(
          (failure) => emit(currentState.copyWith(isLoadingLogos: false)),
          (logos) => emit(
            currentState.copyWith(
              availableLogos: logos,
              isLoadingLogos: false,
            ),
          ),
        );
      }
    });

    // --- MISE À JOUR DU LOGO ---
    on<UpdateCommunityLogoEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(
          currentState.copyWith(
            operationStatus: SectionStatus.loading,
            clearOperationError: true,
            clearSuccessMessage: true,
          ),
        );

        final result = await updateCommunityLogo.call(
          event.communityCode,
          event.logoUrl,
        );
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              operationStatus: SectionStatus.failure,
              operationError: failure.message,
            ),
          ),
          (_) {
            final updatedCommunities = currentState.data.communities.map((c) {
              return c.code == event.communityCode
                  ? c.copyWith(logoUrl: event.logoUrl)
                  : c;
            }).toList();

            final newData = currentState.data.copyWith(
              communities: updatedCommunities,
            );

            final updatedSelected = currentState.selectedCommunity?.code ==
                    event.communityCode
                ? currentState.selectedCommunity!.copyWith(
                    logoUrl: event.logoUrl,
                  )
                : currentState.selectedCommunity;

            emit(
              currentState.copyWith(
                data: newData,
                selectedCommunity: updatedSelected,
                operationStatus: SectionStatus.success,
                successMessage: 'Logo mis à jour',
                clearOperationError: true,
              ),
            );
          },
        );
      }
    });
  }
}
