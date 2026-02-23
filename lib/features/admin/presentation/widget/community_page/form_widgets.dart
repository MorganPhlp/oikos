import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oikos/core/theme/admin_theme.dart';

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
    return Container(
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      decoration: BoxDecoration(
        color: AdminTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.close),
            color: AdminTheme.mutedForeground,
          ),
          const SizedBox(width: AdminTheme.spacingSm),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AdminTheme.foreground,
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
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final hasSuccess = success != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AdminTheme.mutedForeground),
        ),
        const SizedBox(height: AdminTheme.spacingSm),

        // TextField
        TextField(
          controller: controller,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              return newValue.copyWith(text: newValue.text.toUpperCase());
            }),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            filled: true,
            fillColor: AdminTheme.background,
            border: _buildBorder(hasError, false),
            enabledBorder: _buildBorder(hasError, false),
            focusedBorder: _buildBorder(hasError, true),
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
                color: AdminTheme.errorForeground,
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
                color: AdminTheme.successForeground,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(bool hasError, bool isFocused) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
      borderSide: BorderSide(
        color: hasError
            ? AdminTheme.errorForeground
            : isFocused
            ? AdminTheme.actionGreen
            : AdminTheme.border,
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
    return Container(
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      decoration: BoxDecoration(
        color: AdminTheme.background,
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
                  vertical: AdminTheme.spacingMd,
                ),
                side: const BorderSide(color: AdminTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: AdminTheme.spacingMd),

          // Bouton principal
          Expanded(
            child: ElevatedButton(
              onPressed: onSubmit,
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
                        const SizedBox(width: AdminTheme.spacingSm),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AdminTheme.mutedForeground),
        ),
        const SizedBox(height: AdminTheme.spacingSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AdminTheme.spacingMd),
          decoration: BoxDecoration(
            color: AdminTheme.pageBackground,
            borderRadius: BorderRadius.circular(AdminTheme.radiusSm),
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
                    color: AdminTheme.mutedForeground,
                  ),
                ),
            ],
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      decoration: BoxDecoration(
        color: AdminTheme.warningBackground,
        border: Border.all(color: AdminTheme.warningBorder),
        borderRadius: BorderRadius.circular(AdminTheme.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: AdminTheme.warningForeground,
          ),
          const SizedBox(width: AdminTheme.spacingSm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AdminTheme.warningForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
