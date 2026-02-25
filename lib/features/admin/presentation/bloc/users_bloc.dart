import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/aggregates/community_data.dart';
import 'package:oikos/features/admin/domain/use_cases/anonymize_user.dart';
import 'package:oikos/features/admin/domain/use_cases/get_community_data.dart';
import 'package:oikos/features/admin/presentation/bloc/users_event.dart';
import 'package:oikos/features/admin/presentation/bloc/users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetCommunityData getCommunityData;
  final AnonymizeUser anonymizeUser;

  UsersBloc({required this.getCommunityData, required this.anonymizeUser})
    : super(UsersInitial()) {
    on<UsersDataFetched>(_onDataFetched);
    on<UsersSearchChanged>(_onSearchChanged);
    on<UsersCommunityFilterChanged>(_onCommunityFilterChanged);
    on<UsersSortOrderChanged>(_onSortOrderChanged);
    on<UsersAnonymizeRequested>(_onAnonymizeRequested);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HANDLERS
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onDataFetched(
    UsersDataFetched event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getCommunityData(event.companyId);
    result.fold(
      (failure) => emit(UsersError(message: failure.message)),
      (data) => emit(_buildState(data: data)),
    );
  }

  void _onSearchChanged(UsersSearchChanged event, Emitter<UsersState> emit) {
    if (state is! UsersLoaded) return;
    final s = state as UsersLoaded;
    emit(
      _buildState(
        data: s.data,
        searchQuery: event.query,
        selectedCommunityCode: s.selectedCommunityCode,
        sortOrder: s.sortOrder,
      ),
    );
  }

  void _onCommunityFilterChanged(
    UsersCommunityFilterChanged event,
    Emitter<UsersState> emit,
  ) {
    if (state is! UsersLoaded) return;
    final s = state as UsersLoaded;
    emit(
      _buildState(
        data: s.data,
        searchQuery: s.searchQuery,
        selectedCommunityCode: event.communityCode,
        sortOrder: s.sortOrder,
      ),
    );
  }

  void _onSortOrderChanged(
    UsersSortOrderChanged event,
    Emitter<UsersState> emit,
  ) {
    if (state is! UsersLoaded) return;
    final s = state as UsersLoaded;
    emit(
      _buildState(
        data: s.data,
        searchQuery: s.searchQuery,
        selectedCommunityCode: s.selectedCommunityCode,
        sortOrder: event.sortOrder,
      ),
    );
  }

  Future<void> _onAnonymizeRequested(
    UsersAnonymizeRequested event,
    Emitter<UsersState> emit,
  ) async {
    if (state is! UsersLoaded) return;
    final s = state as UsersLoaded;
    emit(s.copyWith(isAnonymizing: true, clearSuccessMessage: true));
    final result = await anonymizeUser(event.user);
    result.fold((failure) => emit(s.copyWith(isAnonymizing: false)), (
      updatedUser,
    ) {
      final updatedUsers = s.data.users
          .map((u) => u.id == updatedUser.id ? updatedUser : u)
          .toList();
      final updatedData = s.data.copyWith(users: updatedUsers);
      emit(
        _buildState(
          data: updatedData,
          searchQuery: s.searchQuery,
          selectedCommunityCode: s.selectedCommunityCode,
          sortOrder: s.sortOrder,
          successMessage: '${event.user.pseudo} a été anonymisé avec succès.',
        ),
      );
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STATE BUILDER
  // ─────────────────────────────────────────────────────────────────────────

  UsersLoaded _buildState({
    required CommunityData data,
    String searchQuery = '',
    String? selectedCommunityCode,
    UsersSortOrder sortOrder = UsersSortOrder.pseudoAsc,
    String? successMessage,
  }) {
    // 1. Exclure seulement les comptes supprimés (anonymisés restent visibles)
    List<Utilisateurs> filtered = data.users
        .where((u) => u.etatCompte != EtatCompte.supprime)
        .toList();

    // 2. Filtre par communauté
    if (selectedCommunityCode != null) {
      filtered = filtered
          .where((u) => u.codeCommunaute == selectedCommunityCode)
          .toList();
    }

    // 3. Recherche textuelle (pseudo ou email)
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (u) =>
                u.pseudo.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q),
          )
          .toList();
    }

    // 4. Tri par pseudo
    if (sortOrder == UsersSortOrder.pseudoAsc) {
      filtered.sort(
        (a, b) => a.pseudo.toLowerCase().compareTo(b.pseudo.toLowerCase()),
      );
    } else {
      filtered.sort(
        (a, b) => b.pseudo.toLowerCase().compareTo(a.pseudo.toLowerCase()),
      );
    }

    return UsersLoaded(
      data: data,
      filteredUsers: filtered,
      searchQuery: searchQuery,
      selectedCommunityCode: selectedCommunityCode,
      sortOrder: sortOrder,
      successMessage: successMessage,
    );
  }
}
