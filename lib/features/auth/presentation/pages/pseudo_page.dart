import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

import 'community_code_page.dart';

class PseudoPage extends StatefulWidget {
  final String email;
  final String password;

  static MaterialPageRoute<dynamic> route({required String email, required String password}) => MaterialPageRoute(
    builder: (context) => PseudoPage(
      email: email,
      password: password,
    ),
  );

  const PseudoPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<PseudoPage> createState() => _PseudoPageState();
}

class _PseudoPageState extends State<PseudoPage> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();

  String? _backendPseudoError;

  @override
  void initState() {
    super.initState();
    _pseudoController.addListener(() {
      if(_backendPseudoError != null) {
        setState(() {
          _backendPseudoError = null;
        });
      }
    });
  }

  String? _validatePseudo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Choisis un petit nom sympa 😊';
    }
    if (value.trim().length < 3) {
      return 'Un peu plus long, au moins 3 caractères 🙂';
    }
    // La regex alphanumérique + tirets est gérée par le inputFormatter ci-dessous
    return _backendPseudoError;
  }

  void _submit() {
    if(_formKey.currentState!.validate()){
      context.read<AuthBloc>().add(
        AuthValidatePseudo(
          pseudo: _pseudoController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.lightIconPrimary, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthFailure) {
            setState(() => _backendPseudoError = state.message);
            _formKey.currentState?.validate();
          }
          if(state is AuthPseudoVerified) {
            Navigator.push(
              context,
              CommunityCodePage.route(
                email: widget.email,
                password: widget.password,
                pseudo: _pseudoController.text.trim(),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Logo
                    Image.asset('assets/logos/oikos_logo.png', height: 60),
                    const SizedBox(height: 20),

                    // Titre
                    Text(
                      "Comment tu t'appelles ?",
                      style: AppTypography.h2,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Ton surnom pour rejoindre ta communauté",
                      style: AppTypography.body.copyWith(
                        color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Champ Pseudo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ton pseudo",
                          style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),

                        AuthField(
                          controller: _pseudoController,
                          maxLength: 20, // Limite visuelle et technique
                          validator: _validatePseudo,
                          // Empêche les caractères spéciaux
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]')),
                          ],
                          hintText: "Ex: EcoHero",
                          prefixIcon: Icons.person_outline,
                        ),

                        // Compteur manuel comme sur la maquette
                        ValueListenableBuilder(
                          valueListenable: _pseudoController,
                          builder: (context, TextEditingValue value, _) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                "${value.text.length}/20 caractères",
                                style: TextStyle(
                                    color: AppColors.lightTextPrimary.withValues(alpha: 0.5),
                                    fontSize: 12
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Bouton Valider
                    AuthPrimaryButton(
                      text: "Valider mon pseudo !",
                      onPressed: _submit,
                    ),

                    const SizedBox(height: 30),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF65BA74).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "💡 Ton pseudo sera visible dans les classements",
                        style: TextStyle(
                          color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}