import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          IconButton(onPressed: onBack, icon: const Icon(Icons.close)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
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
    this.success
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final hasSuccess = success != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 8),

        // TextField
        TextField(
          controller: controller,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              return newValue.copyWith(
                text: newValue.text.toUpperCase(),
              );
            }),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '', // Cache le compteur de caractères
            filled: true,
            fillColor: Colors.white,
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
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        if(hasSuccess)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              success!,
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ), 
      ],
    );
  }

  OutlineInputBorder _buildBorder(bool hasError, bool isFocused) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: hasError
            ? Colors.red
            : isFocused
            ? const Color(0xFF16A34A)
            : Colors.grey[300]!,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2), // Ombre vers le haut
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: 12),

          // Bouton principal
          Expanded(
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                        const SizedBox(width: 8),
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
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
/// Affiche un message d'avertissement avec un emoji et un fond jaune.
class WarningBox extends StatelessWidget {
  final String message;

  const WarningBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        border: Border.all(color: Colors.yellow[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text('⚠️ ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: Colors.yellow[900]),
            ),
          ),
        ],
      ),
    );
  }
}
