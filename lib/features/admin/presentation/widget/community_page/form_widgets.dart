import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/utils/utils.dart';

/// Header pour les formulaires mobile (plein écran)
///
/// Affiche un titre avec un bouton de fermeture à gauche.
/// Utilisé en haut des écrans de formulaire sur mobile.
class FormHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const FormHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      
      child: Row(
        children: [
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Champ de formulaire stylisé
///
/// Encapsule un TextField avec un label, gestion des erreurs,
/// et style cohérent avec le reste de l'application.
class FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? error;
  final String? success;
  final String? hint;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final FilteringTextInputFormatter? inputFormatter;

  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.error,
    this.hint,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.success,
    this.inputFormatter
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    final hasError = error != null;
    final hasSuccess = success != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(fontSize: 14, color: colors.mutedForeground),
        ),
        const SizedBox(height: AppTheme.spacingSm),

        // TextField
        TextField(
          controller: controller,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          inputFormatters: [
            inputFormatter ?? FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              return newValue.copyWith(text: newValue.text.toUpperCase());
            }),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            filled: true,
            fillColor: colors.background,
            border: _buildBorder(hasError, false, colors.border),
            enabledBorder: _buildBorder(hasError, false, colors.border),
            focusedBorder: _buildBorder(hasError, true, colors.border),
          ),
        ),

        // Message d'erreur
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              error!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.errorForeground,
              ),
            ),
          ),
        if (hasSuccess)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              success!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.successForeground,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(bool hasError, bool isFocused, Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      borderSide: BorderSide(
        color: hasError
            ? AppTheme.errorForeground
            : isFocused
            ? AppTheme.actionGreen
            : borderColor,
        width: isFocused ? 2 : 1,
      ),
    );
  }
}

/// Barre d'actions en bas des formulaires
///
/// Affiche deux boutons : Annuler et une action principale (Créer, Enregistrer, etc.)
class FormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitLabel;
  final bool? isSubmitting;

  const FormActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.submitLabel,
    this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bouton Annuler
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMd,
                ),
                side: BorderSide(color: colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),

          // Bouton principal
          Expanded(
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionGreen,
                foregroundColor: AppTheme.actionGreenForeground,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: isSubmitting == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
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

/// Champ en lecture seule (affichage d'information)
///
/// Utilisé pour afficher une valeur non modifiable dans un formulaire.
class ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: colors.mutedForeground),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: colors.pageBackground,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.mutedForeground,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sélecteur de logo inline pour les formulaires de création
///
/// Affiche une grille scrollable (hauteur fixe 200px) avec en premier une
/// option "Aucun" (logo_url → null) puis les avatars disponibles.
/// L'élément sélectionné est mis en valeur par une bordure colorée.
class LogoPickerSection extends StatelessWidget {
  final String? selectedLogoUrl;
  final List<String>? logos;
  final bool isLoading;
  final ValueChanged<String?> onSelect;

  const LogoPickerSection({
    super.key,
    required this.selectedLogoUrl,
    required this.logos,
    required this.isLoading,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Logo (optionnel)',
          style: TextStyle(fontSize: 14, color: colors.mutedForeground),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: colors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            child: _buildContent(colors),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(AdminColors colors) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.actionGreen),
      );
    }

    if (logos == null || logos!.isEmpty) {
      return Center(
        child: Text(
          'Aucun logo disponible',
          style: TextStyle(color: colors.mutedForeground),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 72,
        crossAxisSpacing: AppTheme.spacingSm,
        mainAxisSpacing: AppTheme.spacingSm,
      ),
      itemCount: logos!.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) return _buildNoneItem(colors);
        return _buildLogoItem(logos![index - 1], colors);
      },
    );
  }

  Widget _buildNoneItem(AdminColors colors) {
    final isSelected = selectedLogoUrl == null;
    return GestureDetector(
      onTap: () => onSelect(null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.pageBackground,
          border: Border.all(
            color: isSelected ? AppTheme.actionGreen : colors.border,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Icon(
          Icons.block_rounded,
          color: isSelected ? AppTheme.actionGreen : colors.mutedForeground,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLogoItem(String url, AdminColors colors) {
    final isSelected = selectedLogoUrl == url;
    return GestureDetector(
      onTap: () => onSelect(url),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppTheme.actionGreen : colors.border,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: ClipOval(
          child: Image.network(StorageUtils.getNetworkUrl('avatars', url),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: colors.pageBackground,
              child: Icon(
                Icons.broken_image_rounded,
                color: colors.mutedForeground,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Boîte d'avertissement
///
/// Affiche un message d'avertissement avec une icône et un fond jaune.
class WarningBox extends StatelessWidget {
  final String message;

  const WarningBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.warningBackground,
        border: Border.all(color: AppTheme.warningBorder),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: AppTheme.warningForeground,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.warningForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
