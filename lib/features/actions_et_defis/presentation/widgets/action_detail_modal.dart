import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/oikos_button_theme.dart';

class ActionDetailModal extends StatefulWidget {
  final ActionEntity action;
  final Function(String freq) onJoin;

  const ActionDetailModal({super.key, required this.action, required this.onJoin});

  @override
  State<ActionDetailModal> createState() => _ActionDetailModalState();
}

class _ActionDetailModalState extends State<ActionDetailModal> {
  @override
  Widget build(BuildContext context) {
    // Récupération du thème bouton
    final buttonTheme = Theme.of(context).extension<OikosButtonTheme>();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Stack(
            children: [
              // 1. LISTE SCROLLABLE
              ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  _buildGreenHeader(),
                  const SizedBox(height: 60),

                  // CONTENU
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          "Objectif : ${widget.action.description}",
                          style: const TextStyle(fontSize: 15, color: AppColors.lightMutedForeground, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // ACCORDÉON 1 : COMMENT FAIRE ?
                        _buildAccordion(
                          context,
                          title: "Comment faire ?",
                          icon: Icons.list_alt,
                          initiallyExpanded: true,
                          content: Column(
                            children: widget.action.tips.map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle, color: AppColors.lightPrimary, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(t, style: const TextStyle(color: AppColors.lightTextPrimary))),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ACCORDÉON 2 : POURQUOI ? (AVEC LE COMPTEUR SOCIAL)
                        _buildAccordion(
                          context,
                          title: "Pourquoi c'est important ?",
                          icon: Icons.lightbulb_outline,
                          initiallyExpanded: false,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cette action permet d'économiser environ ${widget.action.co2Saved} de CO2. C'est un geste simple qui a un impact énorme !",
                                style: const TextStyle(color: AppColors.lightTextPrimary, height: 1.5),
                              ),
                              const SizedBox(height: 15),

                              // LE COMPTEUR SOCIAL (Nbres de personnes qui ont deja realisés l'action )
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.lightPrimary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.lightPrimary.withOpacity(0.1)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.groups, color: AppColors.lightPrimary, size: 20),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        "100 personnes ont déjà complété cette action !", // Statique pour l'instant(TODO: Dynamiser ....)
                                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15),

                              // SOURCE ADEME
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.lightMuted.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, size: 14, color: AppColors.lightMutedForeground),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Source : Base Empreinte® ADEME",
                                      style: TextStyle(fontSize: 11, color: AppColors.lightMutedForeground, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 160), // Espace final
                      ],
                    ),
                  ),
                ],
              ),

              // ELEMENTS FLOTTANTS
              Positioned(top: 230, left: 20, right: 20, child: _buildFloatingStatsCard()),
              Positioned(top: 20, left: 20, child: _buildCloseButton(context)),

              // BARRE DU BAS
              Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: _buildBottomBar(context, buttonTheme)
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGETS ---

  Widget _buildGreenHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(widget.action.icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.action.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Text(widget.action.categoryName.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFloatingStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.lightBorder.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
        border: Border.all(color: AppColors.lightInputBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(Icons.bolt, "${widget.action.points} pts", "Gain"),
          Container(width: 1, height: 30, color: AppColors.lightMuted),
          _statItem(Icons.cloud_outlined, widget.action.co2Saved, "CO2"),
          Container(width: 1, height: 30, color: AppColors.lightMuted),
          _statItem(Icons.speed, widget.action.difficulty, "Niveau"),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String val, String label) {
    return Column(children: [
      Icon(icon, color: AppColors.lightPrimary, size: 20),
      const SizedBox(height: 4),
      Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.lightTextPrimary)),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.lightMutedForeground)),
    ]);
  }

  Widget _buildAccordion(BuildContext context, {required String title, required IconData icon, required bool initiallyExpanded, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightInputBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.lightPrimary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.lightPrimary, size: 20),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary)),
          children: [Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), child: content)],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, OikosButtonTheme? buttonTheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // BOUTON PRINCIPAL (GRADIENT)
          Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: buttonTheme?.primaryGradient ?? const LinearGradient(colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (buttonTheme?.shadowColor ?? AppColors.lightPrimary).withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: () => widget.onJoin(widget.action.frequency),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Je relève le défi !", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          const SizedBox(height: 12),

          // 👇 BOUTON "PAS POUR MOI" (Avec la croix devant)
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
            label: Text(
              "Cette action n'est pas pour moi",
              style: TextStyle(color: Colors.grey[500], fontSize: 13, decoration: TextDecoration.underline),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
        child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      ),
    );
  }
}