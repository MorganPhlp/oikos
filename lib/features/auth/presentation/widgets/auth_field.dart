import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Plus besoin d'importer app_colors.dart ici, on passe par le Theme

class AuthField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool isObscured;
  final VoidCallback? onToggleVisibility;
  final int maxLength;
  final List<FilteringTextInputFormatter> inputFormatters;

  const AuthField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.isObscured = false,
    this.onToggleVisibility,
    this.maxLength = 50,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    // On récupère la couleur active du thème (Light ou Dark)
    final primaryColor = Theme.of(context).colorScheme.primary;

    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLength: maxLength > 0 ? maxLength : null,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: "", // Cache le compteur
        // L'icône prend la couleur du thème
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: primaryColor)
            : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: primaryColor,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}
