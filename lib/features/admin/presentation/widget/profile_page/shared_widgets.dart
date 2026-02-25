import 'package:flutter/material.dart';
import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/data/models/models.dart';

// ─── Snackbar helper ─────────────────────────────────────────────────────────

void showProfileSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_rounded : Icons.check_circle_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: AdminTheme.spacingSm),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: isError
          ? AdminTheme.errorForeground
          : AdminTheme.actionGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      ),
    ),
  );
}

// ─── Input decoration helper ─────────────────────────────────────────────────

InputDecoration profileInputDecoration(
  BuildContext context, {
  required String hint,
  required IconData prefixIcon,
  Widget? suffixIcon,
}) {
  final colors = AdminColors.of(context);
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: colors.mutedForeground, fontSize: 14),
    prefixIcon: Icon(prefixIcon, size: 18, color: colors.mutedForeground),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: colors.inputBackground,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AdminTheme.spacingMd,
      vertical: AdminTheme.spacingMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      borderSide: BorderSide(color: colors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      borderSide: BorderSide(color: colors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      borderSide: const BorderSide(color: AdminTheme.actionGreen, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      borderSide: const BorderSide(color: AdminTheme.errorForeground),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      borderSide: const BorderSide(color: AdminTheme.errorForeground, width: 2),
    ),
  );
}

// ─── SectionHeader ───────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AdminTheme.spacingSm),
          decoration: BoxDecoration(
            color: AdminTheme.actionGreenLight,
            borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
          ),
          child: Icon(icon, size: 18, color: AdminTheme.actionGreen),
        ),
        const SizedBox(width: AdminTheme.spacingMd),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ],
    );
  }
}

// ─── FieldLabel ──────────────────────────────────────────────────────────────

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: colors.foreground,
      ),
    );
  }
}

// ─── SaveButton ──────────────────────────────────────────────────────────────

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String label;

  const SaveButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AdminTheme.actionGreen,
        foregroundColor: AdminTheme.actionGreenForeground,
        disabledBackgroundColor: AdminTheme.actionGreen.withValues(alpha: 0.6),
        padding: const EdgeInsets.symmetric(
          horizontal: AdminTheme.spacingXl,
          vertical: AdminTheme.spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
    );
  }
}

// ─── RoleBadge ───────────────────────────────────────────────────────────────

class RoleBadge extends StatelessWidget {
  final RoleUtilisateur role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    final isAdmin = role == RoleUtilisateur.administrateur;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AdminTheme.spacingMd,
        vertical: AdminTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: isAdmin ? AdminTheme.actionGreenLight : colors.muted,
        borderRadius: BorderRadius.circular(AdminTheme.radiusXxl),
        border: Border.all(
          color: isAdmin ? AdminTheme.actionGreen : colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAdmin ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
            size: 14,
            color: isAdmin ? AdminTheme.actionGreen : colors.mutedForeground,
          ),
          const SizedBox(width: AdminTheme.spacingXs),
          Text(
            isAdmin ? 'Administrateur' : 'Utilisateur',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isAdmin ? AdminTheme.actionGreen : colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AvatarEditor ────────────────────────────────────────────────────────────

class AvatarEditor extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const AvatarEditor({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 48,
            backgroundColor: colors.muted,
            backgroundImage: NetworkImage(user.avatarNetworkUrl),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AdminTheme.spacingXs),
            decoration: BoxDecoration(
              color: AdminTheme.actionGreen,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── LogoEditor ──────────────────────────────────────────────────────────────

class LogoEditor extends StatelessWidget {
  final Company company;
  final VoidCallback onTap;

  const LogoEditor({super.key, required this.company, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AdminTheme.radiusXl),
              border: Border.all(color: colors.border),
              color: colors.muted,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              company.logoNetworkUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.business_rounded,
                size: 40,
                color: colors.mutedForeground,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AdminTheme.spacingXs),
            decoration: BoxDecoration(
              color: AdminTheme.actionGreen,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── PickerModalHeader ───────────────────────────────────────────────────────

class PickerModalHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClose;

  const PickerModalHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(AdminTheme.spacingLg),
      child: Row(
        children: [
          Icon(icon, color: AdminTheme.actionGreen),
          const SizedBox(width: AdminTheme.spacingMd),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            color: colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

// ─── PickerModalActions ──────────────────────────────────────────────────────

class PickerModalActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitLabel;
  final bool isSubmitting;

  const PickerModalActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.submitLabel,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AdminTheme.spacingLg,
        0,
        AdminTheme.spacingLg,
        AdminTheme.spacingLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AdminTheme.spacingMd,
                ),
                side: BorderSide(color: colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: AdminTheme.spacingMd),
          Expanded(
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminTheme.actionGreen,
                foregroundColor: AdminTheme.actionGreenForeground,
                padding: const EdgeInsets.symmetric(
                  vertical: AdminTheme.spacingMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
                ),
              ),
              child: isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        Text(submitLabel),
                      ],
                    )
                  : Text(submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PasswordField ───────────────────────────────────────────────────────────

class PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final String hint;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.obscure,
    required this.hint,
    required this.onToggleVisibility,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label),
        const SizedBox(height: AdminTheme.spacingXs),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.mutedForeground, fontSize: 14),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: colors.mutedForeground,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 18,
                color: colors.mutedForeground,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: colors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AdminTheme.spacingMd,
              vertical: AdminTheme.spacingMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              borderSide: const BorderSide(
                color: AdminTheme.actionGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              borderSide: const BorderSide(color: AdminTheme.errorForeground),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              borderSide: const BorderSide(
                color: AdminTheme.errorForeground,
                width: 2,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
