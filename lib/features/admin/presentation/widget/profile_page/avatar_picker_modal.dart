import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';
import 'package:oikos/core/utils/utils.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/shared_widgets.dart';

class AvatarPickerModal extends StatefulWidget {
  const AvatarPickerModal({super.key});

  @override
  State<AvatarPickerModal> createState() => _AvatarPickerModalState();
}

class _AvatarPickerModalState extends State<AvatarPickerModal> {
  String? _selectedAvatarUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _selectedAvatarUrl = state.user.avatarUrl?.isNotEmpty == true
          ? state.user.avatarUrl
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) {
        if (prev is! ProfileLoaded || curr is! ProfileLoaded) return false;
        return prev.profileStatus != curr.profileStatus;
      },
      listener: (context, state) {
        if (state is! ProfileLoaded) return;
        if (state.profileStatus == SectionStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is! ProfileLoaded) return const SizedBox.shrink();

        final colors = AdminColors.of(context);
        final avatars = state.availableAvatars;
        final isLoadingAvatars = state.isLoadingAvatars;
        final isSubmitting = state.profileStatus == SectionStatus.loading;

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
                  title: "Changer l'avatar",
                  icon: Icons.account_circle_outlined,
                  onClose: () => Navigator.pop(context),
                ),
                Divider(height: 1, color: colors.border),
                Flexible(
                  child: isLoadingAvatars
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: AdminTheme.actionGreen,
                            ),
                          ),
                        )
                      : avatars == null || avatars.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Aucun avatar disponible',
                              style: TextStyle(
                                color: colors.mutedForeground,
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
                          itemCount: avatars.length,
                          itemBuilder: (context, index) {
                            final url = avatars[index];
                            final isSelected = _selectedAvatarUrl == url;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedAvatarUrl = url),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AdminTheme.actionGreen
                                        : colors.border,
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(StorageUtils.getPublicUrl('avatars', url)),
                                  backgroundColor: colors.pageBackground,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Divider(height: 1, color: colors.border),
                PickerModalActions(
                  onCancel: () => Navigator.pop(context),
                  onSubmit: () {
                    if (_selectedAvatarUrl != null) {
                      context.read<ProfileBloc>().add(
                        ProfileUpdateAvatar(avatarUrl: _selectedAvatarUrl!),
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
