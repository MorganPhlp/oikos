import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/company_logo_picker_modal.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/shared_widgets.dart';

class CompanyCard extends StatefulWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  State<CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _domainController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name);
    _domainController =
        TextEditingController(text: widget.company.domainEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _saveCompany() {
    if (!_formKey.currentState!.validate()) return;
    final current = context.read<ProfileBloc>().state;
    if (current is! ProfileLoaded) return;
    context.read<ProfileBloc>().add(
      ProfileUpdateCompany(
        company: current.company.copyWith(
          name: _nameController.text.trim(),
          domainEmail: _domainController.text.trim(),
        ),
      ),
    );
  }

  void _showLogoPicker() {
    final bloc = context.read<ProfileBloc>();
    if ((bloc.state as ProfileLoaded).availableLogos == null) {
      bloc.add(ProfileFetchLogos(companyName: widget.company.name));
    }
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const CompanyLogoPickerModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) {
        if (prev is! ProfileLoaded || curr is! ProfileLoaded) return false;
        return prev.companyStatus != curr.companyStatus;
      },
      listener: (context, state) {
        if (state is! ProfileLoaded) return;
        if (state.companyStatus == SectionStatus.success) {
          showProfileSnackBar(context, "Informations entreprise mises à jour");
          context
              .read<AppUserCubit>()
              .updateUser(state.user, company: state.company);
          context.read<ProfileBloc>().add(
            ProfileResetStatus(section: ProfileSection.company),
          );
        } else if (state.companyStatus == SectionStatus.failure) {
          showProfileSnackBar(
            context,
            state.companyError ??
                "Erreur lors de la mise à jour de l'entreprise",
            isError: true,
          );
          context.read<ProfileBloc>().add(
            ProfileResetStatus(section: ProfileSection.company),
          );
        }
      },
      builder: (context, state) {
        if (state is! ProfileLoaded) return const SizedBox.shrink();
        final isLoading = state.companyStatus == SectionStatus.loading;
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: AdminColors.of(context).cardDecoration,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.business_rounded,
                  title: 'Entreprise',
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Center(
                  child: LogoEditor(
                    company: state.company,
                    onTap: _showLogoPicker,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                const FieldLabel(label: "Nom de l'entreprise"),
                const SizedBox(height: AppTheme.spacingXs),
                TextFormField(
                  controller: _nameController,
                  readOnly: true,
                  decoration: profileInputDecoration(
                    context,
                    hint: "Nom de votre entreprise",
                    prefixIcon: Icons.business_rounded,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const FieldLabel(label: 'Domaine email'),
                const SizedBox(height: AppTheme.spacingXs),
                TextFormField(
                  controller: _domainController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: profileInputDecoration(
                    context,
                    hint: 'domaine.com',
                    prefixIcon: Icons.alternate_email_rounded,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Le domaine email est requis'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: SaveButton(
                    onPressed: _saveCompany,
                    isLoading: isLoading,
                    label: "Enregistrer l'entreprise",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
