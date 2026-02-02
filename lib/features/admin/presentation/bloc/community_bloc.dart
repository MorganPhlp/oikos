import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';
import 'package:oikos/features/admin/domain/use_cases/delete_community.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_code.dart';
import 'package:oikos/features/admin/domain/use_cases/update_user.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'package:oikos/features/admin/domain/use_cases/get_community_data.dart';
import 'package:uuid/uuid.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final GetCommunityData getCommunityData;
  final UpdateCommunityCode updateCommunityCode;
  final UpdateUser updateUser;
  final CreateCommunity createCommunity;
  final DeleteCommunity deleteCommunity;

  CommunityBloc({
    required this.getCommunityData,
    required this.updateCommunityCode,
    required this.updateUser,
    required this.createCommunity,
    required this.deleteCommunity,
  }) : super(CommunityInitial()) {
    // --- CHARGEMENT DES DONNÉES ---
    on<CommunityDataFetched>((event, emit) async {
      emit(CommunityLoading());
      try {
        final data = await getCommunityData.call();
        emit(CommunityLoaded(data: data));
      } catch (e) {
        emit(
          CommunityFetchingError(
            message: "Erreur lors du chargement des données",
          ),
        );
      }
    });

    // --- MISE À JOUR DU CODE ---
    on<UpdateCommunityCodeEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        await Future.delayed(Duration(seconds: 2), () {});

        try {
          await updateCommunityCode.call(event.newCode, event.communityId);

          // Mise à jour de la communauté modifiée
          final updatedCommunities = currentState.data.communities.map((c) {
            return c.id == event.communityId
                ? c.copyWith(code: event.newCode)
                : c;
          }).toList();

          final newData = currentState.data.copyWith(
            communities: updatedCommunities,
          );

          emit(CommunityLoaded(data: newData, updateSuccess: true));
        } on DuplicateCodeException catch (e) {
          emit(currentState.copyWith(errorMessage: e.message));
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors de la création de la communauté",
            ),
          );
        }
      }
    });

    // --- MISE À JOUR UTILISATEUR ---
    on<UpdateUserEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));
        try {
          await updateUser.call(event.user);

          // Mise à jour de l'utilisateur modifié
          final updatedUsers = currentState.data.users.map((user) {
            return user.id == event.user.id ? event.user : user;
          }).toList();

          final newData = currentState.data.copyWith(users: updatedUsers);

          emit(CommunityLoaded(data: newData, updateSuccess: true));
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors de la mise à jour",
            ),
          );
        }
      }
    });

    on<SelectedCommunityEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        // On crée une copie de l'état actuel mais on change seulement la sélection
        final community = currentState.data.communities[event.index];
        final users = currentState.data.users
            .where((u) => u.communityId == community.id)
            .toList();
        emit(
          currentState.copyWith(
            selectedCommunity: community,
            selectedUsers: users,
          ),
        );
      }
    });

    // L'événement de reset de l'état
    on<ResetCommunityStatusEvent>((event, emit) {
      if (state is CommunityLoaded) {
        emit(
          (state as CommunityLoaded).copyWith(
            updateSuccess: false,
            isSubmitting: false,
            errorMessage: null, // On en profite pour nettoyer l'erreur
          ),
        );
      }
    });

    // --- CHANGEMENT DE COMMUNAUTÉ D'UN UTILISATEUR ---
    on<ChangeUserCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));
        try {
          // Trouver l'utilisateur et mettre à jour sa communauté
          final user = currentState.data.users.firstWhere(
            (u) => u.id == event.userId,
          );
          final updatedUser = user.copyWith(communityId: () => event.newCommunityId);

          await updateUser.call(updatedUser);

          // Mise à jour locale de l'utilisateur
          final updatedUsers = currentState.data.users.map((u) {
            return u.id == event.userId ? updatedUser : u;
          }).toList();

          // Mise à jour du nombre de membres des communautés concernées
          final updatedCommunities = currentState.data.communities.map((c) {
            if (c.id == user.communityId) {
              // Ancienne communauté : -1 membre
              return c.copyWith(membersCount: c.membersCount - 1);
            } else if (c.id == event.newCommunityId) {
              // Nouvelle communauté : +1 membre
              return c.copyWith(membersCount: c.membersCount + 1);
            }
            return c;
          }).toList();

          final newData = currentState.data.copyWith(
            users: updatedUsers,
            communities: updatedCommunities,
          );

          // Mettre à jour selectedUsers si on est sur la vue des membres
          final newSelectedUsers = currentState.selectedCommunity != null
              ? updatedUsers
                    .where(
                      (u) =>
                          u.communityId == currentState.selectedCommunity!.id,
                    )
                    .toList()
              : currentState.selectedUsers;

          emit(
            currentState.copyWith(
              data: newData,
              selectedUsers: newSelectedUsers,
              isSubmitting: false,
              updateSuccess: true,
            ),
          );
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors du changement de communauté",
            ),
          );
        }
      }
    });

    // --- SUPPRESSION D'UN UTILISATEUR D'UNE COMMUNAUTÉ ---
    on<RemoveUserFromCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));
        try {
          // Trouver l'utilisateur et retirer sa communauté
          final user = currentState.data.users.firstWhere(
            (u) => u.id == event.userId,
          );
          final oldCommunityId = user.communityId;
          final updatedUser = user.copyWith(communityId: () => null);

          await updateUser.call(updatedUser);

          // Mise à jour locale de l'utilisateur
          final updatedUsers = currentState.data.users.map((u) {
            return u.id == event.userId ? updatedUser : u;
          }).toList();

          // Mise à jour du nombre de membres de l'ancienne communauté
          final updatedCommunities = currentState.data.communities.map((c) {
            if (c.id == oldCommunityId) {
              return c.copyWith(membersCount: c.membersCount - 1);
            }
            return c;
          }).toList();

          final newData = currentState.data.copyWith(
            users: updatedUsers,
            communities: updatedCommunities,
          );

          // Mettre à jour selectedUsers si on est sur la vue des membres
          final newSelectedUsers = currentState.selectedCommunity != null
              ? updatedUsers
                    .where(
                      (u) =>
                          u.communityId == currentState.selectedCommunity!.id,
                    )
                    .toList()
              : currentState.selectedUsers;

          emit(
            currentState.copyWith(
              data: newData,
              selectedUsers: newSelectedUsers,
              isSubmitting: false,
              updateSuccess: true,
            ),
          );
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors de la suppression de l'utilisateur",
            ),
          );
        }
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
          case MobileView.createCommunity:
          case MobileView.editCode:
          case MobileView.deleteConfirm:
            // Retour à la liste principale
            emit(
              currentState.copyWith(
                currentMobileView: MobileView.list,
                selectedCommunity: null,
              ),
            );
            break;
          case MobileView.changeUser:
            // Retour à la liste des membres
            emit(
              currentState.copyWith(
                currentMobileView: MobileView.members,
                selectedUser: null,
              ),
            );
            break;
          case MobileView.list:
            // Déjà à la racine
            break;
        }
      }
    });

    // --- SÉLECTION UTILISATEUR ---
    on<SelectUserEvent>((event, emit) {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        // Initialise selectedNewCommunityId avec la communauté actuelle de l'utilisateur
        emit(
          currentState.copyWith(
            selectedUser: event.user,
            selectedNewCommunityId: event.user.communityId,
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
        if (user.communityId == newCommunityId) return; // Pas de changement

        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));
        try {
          final updatedUser = user.copyWith(communityId: () => newCommunityId);

          await updateUser.call(updatedUser);

          // Mise à jour locale de l'utilisateur
          final updatedUsers = currentState.data.users.map((u) {
            return u.id == user.id ? updatedUser : u;
          }).toList();

          // Mise à jour du nombre de membres des communautés concernées
          final updatedCommunities = currentState.data.communities.map((c) {
            if (c.id == user.communityId) {
              return c.copyWith(membersCount: c.membersCount - 1);
            } else if (c.id == newCommunityId) {
              return c.copyWith(membersCount: c.membersCount + 1);
            }
            return c;
          }).toList();

          final newData = currentState.data.copyWith(
            users: updatedUsers,
            communities: updatedCommunities,
          );

          // Mettre à jour selectedUsers si on est sur la vue des membres
          final newSelectedUsers = currentState.selectedCommunity != null
              ? updatedUsers
                    .where(
                      (u) =>
                          u.communityId == currentState.selectedCommunity!.id,
                    )
                    .toList()
              : currentState.selectedUsers;

          emit(
            currentState.copyWith(
              data: newData,
              selectedUsers: newSelectedUsers,
              isSubmitting: false,
              updateSuccess: true,
            ),
          );
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors du changement de communauté",
            ),
          );
        }
      }
    });

    on<CreateNewCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        try {
          emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));
          var uuid = const Uuid();
          final String id = uuid.v4(); // Génère un UUID type

          await createCommunity.call(
            name: event.name,
            code: event.code,
            companyId: event.companyId,
            id: id,
          );

          final updatedCommunites = [
            ...currentState.data.communities,
            Community(
              id: id,
              name: event.name,
              code: event.code,
              companyId: event.companyId,
              membersCount: 0,
              avgScore: null,
            ),
          ];
          final newData = currentState.data.copyWith(
            communities: updatedCommunites,
          );
          emit(
            currentState.copyWith(
              updateSuccess: true,
              isSubmitting: false,
              data: newData,
            ),
          );
        } on DuplicateCodeException catch (e) {
          emit(currentState.copyWith(errorMessage: e.message));
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors de la création de la communauté",
            ),
          );
        }
      }
    });

    // --- SUPPRESSION COMMUNAUTÉ ---
    on<DeleteCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));
        try {
          await deleteCommunity.call(event.communityId);

          final updatedCommunities = currentState.data.communities
              .where((c) => c.id != event.communityId)
              .toList();

          final newData = currentState.data.copyWith(
            communities: updatedCommunities,
          );

          emit(
            currentState.copyWith(
              data: newData,
              isSubmitting: false,
              updateSuccess: true,
            ),
          );
        } catch (e) {
          emit(
            currentState.copyWith(
              errorMessage: "Erreur lors de la suppression de la communauté",
            ),
          );
        }
      }
    });

    add(CommunityDataFetched());
  }
}
