import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

class UpdatePseudoModal extends StatefulWidget {
  final String currentPseudo;
  final ValueChanged<String> onPseudoValidated;

  const UpdatePseudoModal({
    super.key,
    required this.currentPseudo,
    required this.onPseudoValidated,
  });

  @override
  State<UpdatePseudoModal> createState() => _UpdatePseudoModalState();
}

class _UpdatePseudoModalState extends State<UpdatePseudoModal> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPseudo);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onPseudoValidated(_controller.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Padding pour gérer le clavier virtuel
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'Modifier le pseudo',
                style: AppTypography.h2.copyWith(
                  color: colorScheme.primary,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 24),

              AuthField(
                hintText: 'Nouveau pseudo',
                controller: _controller,
                prefixIcon: LucideIcons.user, // Icône cohérente avec le reste
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un pseudo';
                  }
                  if (value.length < 2) {
                    return 'Le pseudo doit contenir au moins 2 caractères';
                  }
                  if (value.length > 20) {
                    return 'Le pseudo ne peut pas dépasser 20 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              AuthPrimaryButton(text: 'Enregistrer', onPressed: _submit),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
