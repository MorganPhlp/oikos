import 'package:flutter/material.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ForgotPasswordModal extends StatefulWidget {
  final String email;
  const ForgotPasswordModal({super.key, required this.email});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  void _resetPassword() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isSuccess = true;
      });
      // TODO : Appel API reset password
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightTextPrimary
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.lightTextPrimary.withValues(alpha: 0.4)),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
            const SizedBox(height: 15),

            Text(
              "Pas de souci ! Entre ton email et on t'envoie un lien pour créer un nouveau mot de passe 😊",
              style: TextStyle(color: AppColors.lightTextPrimary.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 20),

            if (_isSuccess)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "✅ Un email de réinitialisation a été envoyé !",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              )
            else
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Ton email pro',
                      style: AppTypography.body.copyWith(
                        color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    AuthField(
                      hintText: "prenom.nom@entreprise.fr",
                      controller: _emailController,
                      prefixIcon: Icons.mail_outline,
                      // TODO : Ajouter règles de validation email
                    ),

                    const SizedBox(height: 20),

                    AuthPrimaryButton(
                      text: "Réinitialiser le mot de passe",
                      onPressed: _resetPassword,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
