import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';
import 'package:oikos/features/admin/domain/use_cases/delete_community.dart';
import 'package:oikos/features/admin/domain/use_cases/update_community_code.dart';
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
      final result = await getCommunityData.call();
      result.fold(
        (failure) => emit(CommunityFetchingError(message: failure.message)),
        (data) => emit(CommunityLoaded(data: data)),
      );
    });

    // --- MISE À JOUR DU CODE ---
    on<UpdateCommunityCodeEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final result = await updateCommunityCode.call(
          event.newCode,
          event.communityId,
        );
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
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

            emit(CommunityLoaded(data: newData, updateSuccess: true));
          },
        );
      }
    });

    // --- MISE À JOUR UTILISATEUR ---
    on<UpdateUserEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final result = await updateUser.call(event.user);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
            ),
          ),
          (_) {
            final updatedUsers = currentState.data.users.map((user) {
              return user.id == event.user.id ? event.user : user;
            }).toList();

            final newData = currentState.data.copyWith(users: updatedUsers);
            emit(CommunityLoaded(data: newData, updateSuccess: true));
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

    on<ResetCommunityStatusEvent>((event, emit) {
      if (state is CommunityLoaded) {
        emit(
          (state as CommunityLoaded).copyWith(
            updateSuccess: false,
            isSubmitting: false,
            errorMessage: null,
          ),
        );
      }
    });

    // --- CHANGEMENT DE COMMUNAUTÉ D'UN UTILISATEUR ---
    on<ChangeUserCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final user = currentState.data.users.firstWhere(
          (u) => u.id == event.userId,
        );
        final updatedUser = user.copyWith(codeCommunaute: event.newCommunityId);

        final result = await updateUser.call(updatedUser);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
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
                isSubmitting: false,
                updateSuccess: true,
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
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final user = currentState.data.users.firstWhere(
          (u) => u.id == event.userId,
        );
        final oldCommunityId = user.codeCommunaute;
        final updatedUser = user.copyWith(codeCommunaute: '');

        final result = await updateUser.call(updatedUser);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
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
                isSubmitting: false,
                updateSuccess: true,
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
          case MobileView.createCommunity:
          case MobileView.editCode:
          case MobileView.deleteConfirm:
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

        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final updatedUser = user.copyWith(codeCommunaute: newCommunityId);
        final result = await updateUser.call(updatedUser);

        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
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
                isSubmitting: false,
                updateSuccess: true,
              ),
            );
          },
        );
      }
    });

    on<CreateNewCommunityEvent>((event, emit) async {
      final currentState = state;
      if (currentState is CommunityLoaded) {
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final newCommunity = Community(
          code: event.code,
          name: event.name,
          companyId: event.companyId,
          description: '',
        );

        final result = await createCommunity.call(newCommunity);

        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
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
                updateSuccess: true,
                isSubmitting: false,
                data: newData,
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
        emit(currentState.copyWith(isSubmitting: true, updateSuccess: false));

        final result = await deleteCommunity.call(event.communityId);
        result.fold(
          (failure) => emit(
            currentState.copyWith(
              errorMessage: failure.message,
              isSubmitting: false,
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
                isSubmitting: false,
                updateSuccess: true,
              ),
            );
          },
        );
      }
    });

    add(CommunityDataFetched());
  }
}
