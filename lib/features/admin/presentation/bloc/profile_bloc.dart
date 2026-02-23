import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/admin/domain/use_cases/get_avatars.dart';
import 'package:oikos/features/admin/domain/use_cases/get_company_info.dart';
import 'package:oikos/features/admin/domain/use_cases/get_logos.dart';
import 'package:oikos/features/admin/domain/use_cases/update_company.dart';
import 'package:oikos/features/admin/domain/use_cases/update_user.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUser updateUser;
  final GetCompanyInfo getCompanyInfo;
  final UpdateCompany updateCompanyInfo;
  final GetAvatars getAvatars;
  final GetLogos getLogos;

  ProfileBloc({
    required this.updateUser,
    required this.getCompanyInfo,
    required this.updateCompanyInfo,
    required this.getAvatars,
    required this.getLogos,
  }) : super(ProfileInitial()) {
    // ── Initialisation ───────────────────────────────────────────────────────
    on<ProfileInitEvent>((event, emit) {
      emit(ProfileLoaded(user: event.user, company: event.company));
    });

    // ── Mise à jour du profil (pseudo / email) ───────────────────────────────
    on<ProfileUpdateUser>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(
        current.copyWith(
          profileStatus: SectionStatus.loading,
          clearProfileError: true,
        ),
      );

      final result = await updateUser.call(event.user);
      result.fold(
        (failure) => emit(
          current.copyWith(
            profileStatus: SectionStatus.failure,
            profileError: failure.message,
          ),
        ),
        (_) => emit(
          current.copyWith(
            user: event.user,
            profileStatus: SectionStatus.success,
            clearProfileError: true,
          ),
        ),
      );
    });

    // ── Mise à jour de l'entreprise (nom / domaine email) ────────────────────
    on<ProfileUpdateCompany>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(
        current.copyWith(
          companyStatus: SectionStatus.loading,
          clearCompanyError: true,
        ),
      );

      final result = await updateCompanyInfo.call(event.company);
      result.fold(
        (failure) => emit(
          current.copyWith(
            companyStatus: SectionStatus.failure,
            companyError: failure.message,
          ),
        ),
        (_) => emit(
          current.copyWith(
            company: event.company,
            companyStatus: SectionStatus.success,
            clearCompanyError: true,
          ),
        ),
      );
    });

    // ── Changement de mot de passe (mock — repository ne fait rien) ──────────
    on<ProfileChangePassword>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(
        current.copyWith(
          passwordStatus: SectionStatus.loading,
          clearPasswordError: true,
        ),
      );

      // TODO: appeler le repository de mot de passe quand il sera implémenté.
      emit(
        current.copyWith(
          passwordStatus: SectionStatus.success,
          clearPasswordError: true,
        ),
      );
    });

    // ── Remise à zéro du statut après affichage du feedback ──────────────────
    on<ProfileResetStatus>((event, emit) {
      final current = state;
      if (current is! ProfileLoaded) return;

      switch (event.section) {
        case ProfileSection.profile:
          emit(
            current.copyWith(
              profileStatus: SectionStatus.idle,
              clearProfileError: true,
            ),
          );
        case ProfileSection.company:
          emit(
            current.copyWith(
              companyStatus: SectionStatus.idle,
              clearCompanyError: true,
            ),
          );
        case ProfileSection.password:
          emit(
            current.copyWith(
              passwordStatus: SectionStatus.idle,
              clearPasswordError: true,
            ),
          );
      }
    });

    // ── Chargement des avatars disponibles ───────────────────────────────────
    on<ProfileFetchAvatars>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(current.copyWith(isLoadingAvatars: true));

      final result = await getAvatars.call();
      result.fold(
        (failure) => emit(current.copyWith(isLoadingAvatars: false)),
        (avatars) => emit(
          current.copyWith(availableAvatars: avatars, isLoadingAvatars: false),
        ),
      );
    });

    // ── Chargement des logos disponibles ────────────────────────────────────
    on<ProfileFetchLogos>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(current.copyWith(isLoadingLogos: true));

      final result = await getLogos.call();
      result.fold(
        (failure) => emit(current.copyWith(isLoadingLogos: false)),
        (logos) => emit(
          current.copyWith(availableLogos: logos, isLoadingLogos: false),
        ),
      );
    });

    // ── Mise à jour de l'avatar de l'administrateur ──────────────────────────
    on<ProfileUpdateAvatar>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(current.copyWith(
        profileStatus: SectionStatus.loading,
        clearProfileError: true,
      ));

      final updatedUser = current.user.copyWith(avatarUrl: event.avatarUrl);
      final result = await updateUser.call(updatedUser);
      result.fold(
        (failure) => emit(
          current.copyWith(
            profileStatus: SectionStatus.failure,
            profileError: failure.message,
          ),
        ),
        (_) => emit(
          current.copyWith(
            user: updatedUser,
            profileStatus: SectionStatus.success,
            clearProfileError: true,
          ),
        ),
      );
    });

    // ── Mise à jour du logo de l'entreprise ─────────────────────────────────
    on<ProfileUpdateCompanyLogo>((event, emit) async {
      final current = state;
      if (current is! ProfileLoaded) return;

      emit(current.copyWith(
        companyStatus: SectionStatus.loading,
        clearCompanyError: true,
      ));

      final updatedCompany = current.company.copyWith(logoUrl: event.logoUrl);
      final result = await updateCompanyInfo.call(updatedCompany);
      result.fold(
        (failure) => emit(
          current.copyWith(
            companyStatus: SectionStatus.failure,
            companyError: failure.message,
          ),
        ),
        (_) => emit(
          current.copyWith(
            company: updatedCompany,
            companyStatus: SectionStatus.success,
            clearCompanyError: true,
          ),
        ),
      );
    });
  }
}
