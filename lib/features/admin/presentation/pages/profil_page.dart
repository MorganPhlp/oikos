import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/company_card.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/password_card.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/profile_card.dart';

class ProfilPage extends StatefulWidget {
  final Utilisateurs user;
  final Company company;

  const ProfilPage({super.key, required this.user, required this.company});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(
      ProfileInitEvent(user: widget.user, company: widget.company),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = Breakpoints.isDesktop(constraints.maxWidth);
            return SingleChildScrollView(
              padding: EdgeInsets.all(
                isDesktop ? AdminTheme.spacingLg : AdminTheme.spacingMd,
              ),
              child: isDesktop
                  ? _DesktopLayout(state: state)
                  : _MobileLayout(state: state),
            );
          },
        );
      },
    );
  }
}

// ─── Layouts ─────────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  final ProfileLoaded state;

  const _DesktopLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ProfileCard(user: state.user)),
              const SizedBox(width: AdminTheme.spacingLg),
              Expanded(child: CompanyCard(company: state.company)),
            ],
          ),
        ),
        const SizedBox(height: AdminTheme.spacingLg),
        const PasswordCard(),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ProfileLoaded state;

  const _MobileLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileCard(user: state.user),
        const SizedBox(height: AdminTheme.spacingMd),
        CompanyCard(company: state.company),
        const SizedBox(height: AdminTheme.spacingMd),
        const PasswordCard(),
      ],
    );
  }
}
