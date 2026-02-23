import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/shared_widgets.dart';

class CompanyLogoPickerModal extends StatefulWidget {
  const CompanyLogoPickerModal({super.key});

  @override
  State<CompanyLogoPickerModal> createState() =>
      _CompanyLogoPickerModalState();
}

class _CompanyLogoPickerModalState extends State<CompanyLogoPickerModal> {
  String? _selectedLogoUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _selectedLogoUrl = state.company.logoUrl?.isNotEmpty == true
          ? state.company.logoUrl
          : null;
    }
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
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is! ProfileLoaded) return const SizedBox.shrink();

        final logos = state.availableLogos;
        final isLoadingLogos = state.isLoadingLogos;
        final isSubmitting = state.companyStatus == SectionStatus.loading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminTheme.radiusXl),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 560),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PickerModalHeader(
                  title: 'Changer le logo',
                  icon: Icons.image_outlined,
                  onClose: () => Navigator.pop(context),
                ),
                const Divider(height: 1, color: AdminTheme.border),
                Flexible(
                  child: isLoadingLogos
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: AdminTheme.actionGreen,
                            ),
                          ),
                        )
                      : logos == null || logos.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Aucun logo disponible',
                              style: TextStyle(
                                color: AdminTheme.mutedForeground,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AdminTheme.spacingMd),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: AdminTheme.spacingMd,
                                mainAxisSpacing: AdminTheme.spacingMd,
                              ),
                          itemCount: logos.length,
                          itemBuilder: (context, index) {
                            final url = logos[index];
                            final isSelected = _selectedLogoUrl == url;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedLogoUrl = url),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AdminTheme.radiusLg,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AdminTheme.actionGreen
                                        : AdminTheme.border,
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AdminTheme.radiusMd,
                                  ),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: AdminTheme.pageBackground,
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        color: AdminTheme.mutedForeground,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(height: 1, color: AdminTheme.border),
                PickerModalActions(
                  onCancel: () => Navigator.pop(context),
                  onSubmit: () {
                    if (_selectedLogoUrl != null) {
                      context.read<ProfileBloc>().add(
                        ProfileUpdateCompanyLogo(logoUrl: _selectedLogoUrl!),
                      );
                    }
                  },
                  submitLabel: 'Enregistrer',
                  isSubmitting: isSubmitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
