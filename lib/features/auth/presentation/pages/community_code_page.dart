import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/widgets/loader.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../widgets/confirm_community_modal.dart';

class CommunityCodePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route({
    required String email,
    required String password,
    required String pseudo,
  }) => MaterialPageRoute(
    builder: (context) =>
        CommunityCodePage(email: email, password: password, pseudo: pseudo),
  );

  final String email;
  final String password;
  final String pseudo;

  const CommunityCodePage({
    super.key,
    required this.email,
    required this.password,
    required this.pseudo,
  });

  @override
  State<CommunityCodePage> createState() => _CommunityCodePageState();
}

class _CommunityCodePageState extends State<CommunityCodePage> {
  final _pinController = TextEditingController();
  String? _errorText;

  String? _companyName;
  String? _companyLogoUrl;

  @override
  void initState() {
    super.initState();
    // Récupération du nom de l'entreprise et du logo si nécessaire
    context.read<AuthBloc>().add(AuthLoadCompanyInfo(email: widget.email));
  }

  // Fonction pour valider le code communauté
  void _validateCode(String code) {
    setState(() => _errorText = null);

    final upperCode = code.toUpperCase();

    // Déclenche l'événement pour vérifier le code communauté
    context.read<AuthBloc>().add(AuthVerifyCommunity(communityCode: upperCode));
  }

  @override
  Widget build(BuildContext context) {
    // Style par défaut des cases du PIN
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.lightInputBorderFocused.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.lightInputBorderFocused, width: 2),
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Gérer les états de succès ou d'erreur ici si nécessaire
        if (state is AuthFailure) {
          setState(() => _errorText = state.message);
        }

        // L'entreprise a été chargée avec succès
        if (state is AuthCompanyInfoLoaded) {
          setState(() {
            _companyName = state.companyName;
            _companyLogoUrl = state.logoUrl;
          });
        }

        // Le code communauté a été vérifié avec succès
        if (state is AuthCommunityVerified) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => ConfirmCommunityModal(
              communityName: state.communityName,
              communityIcon:
                  _companyLogoUrl ??
                  '', // Utilise le logo de l'entreprise si disponible
              onConfirm: () {
                // Ferme la modale
                Navigator.popUntil(dialogContext, (route) => route.isFirst);

                // Déclenche l'événement d'inscription avec le context de la page
                context.read<AuthBloc>().add(
                  AuthSignUp(
                    email: widget.email,
                    password: widget.password,
                    pseudo: widget.pseudo,
                    communityCode: _pinController.text.toUpperCase(),
                  ),
                );
              },
              onCancel: () {
                Navigator.pop(dialogContext); // Ferme la modale
                _pinController.clear(); // Réinitialise le champ de saisie
              },
            ),
          );
        }

        // L'inscription est réussie - la navigation est gérée automatiquement par main.dart
        // Le BlocSelector détecte AppUserLoggedIn et affiche BilanPage
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Logo
                      Image.asset('assets/logos/oikos_logo.png', height: 60),
                      const SizedBox(height: 20),

                      // Carte Entreprise (Facultatif, selon la maquette)
                      if (_companyName != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.gradientGreenStart.withValues(
                                  alpha: 0.3,
                                ),
                                AppColors.gradientGreenEnd.withValues(
                                  alpha: 0.3,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Entreprise détectée",
                                    style: TextStyle(
                                      color: AppColors.lightTextPrimary
                                          .withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _companyName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 40),

                      // Icône Sparkles (si pas logo) ou logo entreprise
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.gradientGreenStart,
                              AppColors.gradientGreenEnd,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _companyLogoUrl != null
                            ? ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.network(
                                    _companyLogoUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.business,
                                              color: AppColors.lightTextPrimary,
                                              size: 40,
                                            ),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 40,
                              ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Rejoignez votre communauté",
                        style: AppTypography.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Saisissez le code fourni par votre administrateur pour rejoindre votre équipe",
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(
                          color: AppColors.lightTextPrimary.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "Code communauté",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // INPUT PIN
                      Pinput(
                        controller: _pinController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        textCapitalization: TextCapitalization.characters,
                        onCompleted: _validateCode,
                        onChanged: (_) {
                          if (_errorText != null) {
                            setState(() => _errorText = null);
                          }
                        },
                      ),

                      if (_errorText != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade500,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorText!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // Info Card Bas de page
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gradientGreenStart.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.lightIconPrimary,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Vous n'avez pas de code ? Contactez l'administrateur de votre entreprise.",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Loader par-dessus le contenu si en chargement
              if (state is AuthLoading) const Loader(),
            ],
          ),
        );
      },
    );
  }
}
