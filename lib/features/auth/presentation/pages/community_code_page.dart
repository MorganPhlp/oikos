import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/widgets/loader.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../widgets/confirm_community_modal.dart';


class CommunityCodePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route({required String email, required String password, required String pseudo}) => MaterialPageRoute(
    builder: (context) => CommunityCodePage(
        email: email,
        password: password,
        pseudo: pseudo,
    ),
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
  String? _loadedLogoUrl;

  // Logique pour extraire le nom de l'entreprise de l'email
  String get _companyName {
    final parts = widget.email.split('@');
    if (parts.length > 1) {
      final domain = parts[1].split('.')[0];
      // Met la première lettre en majuscule
      return domain[0].toUpperCase() + domain.substring(1);
    }
    return "Entreprise";
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
      textStyle: const TextStyle(fontSize: 20, color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightInputBorderFocused.withValues(alpha: 0.3), width: 2),
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

        if (state is AuthCommunityVerified) {
          if(state.logoUrl != null) {
            setState(() => _loadedLogoUrl = state.logoUrl);
          }

          // Le code est valide, afficher la modale de confirmation
          showDialog(
            context: context,
            builder: (context) => ConfirmCommunityModal(
              communityName: state.communityName,
              communityIcon: state.logoUrl ?? '',
              onConfirm: () {
                // Déclenche l'événement d'inscription
                context.read<AuthBloc>().add(AuthSignUp(email: widget.email, password: widget.password, pseudo: widget.pseudo, communityCode: _pinController.text.toUpperCase()));
                Navigator.popUntil(context, (route) => route.isFirst); // Ferme toutes les modales et revient à la page principale
              },
              onCancel: () {
                Navigator.pop(context); // Ferme la modale
                _pinController.clear(); // Réinitialise le champ de saisie
                setState(() => _loadedLogoUrl = null); // Réinitialise le logo chargé
              },
            ),
          );
        }
      },
      builder: (context, state) {
        // Afficher un loader si l'état est en cours de chargement et que le PIN n'est pas complet
        if(state is AuthLoading && _pinController.length != 6) {
          // Afficher un indicateur de chargement
          return const Loader();
        }

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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gradientGreenStart.withValues(alpha: 0.3),
                              AppColors.gradientGreenEnd.withValues(alpha: 0.3)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Entreprise détectée", style: TextStyle(color: AppColors.lightTextPrimary.withValues(alpha: 0.6), fontSize: 12)),
                                Text(_companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Icône Sparkles (si pas logo) ou logo entreprise
                      // TODO: Vérifier quel logo par défaut utiliser
                      // TODO: Vérifier l'entreprise pour charger le logo
                      Container(
                        width: 80, height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
                          ),
                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 4))],
                        ),
                        child: _loadedLogoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                _loadedLogoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, color: AppColors.lightTextPrimary, size: 40),
                              ),
                            )
                          : const Icon(Icons.auto_awesome, color: Colors.white, size: 40)
                      ),

                      const SizedBox(height: 24),

                      Text("Rejoignez votre communauté", style: AppTypography.h2, textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Text(
                        "Saisissez le code fourni par votre administrateur pour rejoindre votre équipe",
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(color: AppColors.lightTextPrimary.withValues(alpha: 0.7)),
                      ),

                      const SizedBox(height: 30),

                      Text("Code communauté", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary)),
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
                          if(_errorText != null) {
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
                              Icon(Icons.error_outline, color: Colors.red.shade500, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_errorText!, style: TextStyle(color: Colors.red.shade700))),
                            ],
                          ),
                        )
                      ],

                      const SizedBox(height: 30),

                      // Info Card Bas de page
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gradientGreenStart.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.lightIconPrimary),
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
            ],
          ),
        );
      },
    );
  }
}