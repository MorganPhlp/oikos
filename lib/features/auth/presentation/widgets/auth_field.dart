import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:oikos/core/theme/app_colors.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final IconData ? prefixIcon;
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
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      // style: const TextStyle(color: AppColors.lightTextPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColors.lightIconPrimary),
        suffixIcon: isPassword
          ? IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.lightIconPrimary,
            ),
            onPressed: onToggleVisibility,
          )
          : null,
      ),
    );
  }
}
