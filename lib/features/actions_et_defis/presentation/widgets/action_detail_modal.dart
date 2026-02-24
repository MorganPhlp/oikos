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
    final buttonTheme = Theme.of(context).extension<OikosButtonTheme>();
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Scaffold(
            backgroundColor: colors.surface,
            // Barre d'action fixée en bas
            bottomNavigationBar: _buildBottomBar(context, buttonTheme, colors, isDarkMode),

            body: Stack(
              children: [
                ListView(
                  controller: controller,
                  padding: EdgeInsets.zero,
                  children: [
                    // En-tête visuel avec titre et icône
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildGreenHeader(),
                        Positioned(
                          bottom: -30,
                          left: 20,
                          right: 20,
                          child: _buildFloatingStatsCard(colors, isDarkMode),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            "Objectif : ${widget.action.description}",
                            style: TextStyle(
                              fontSize: 15,
                              color: colors.onSurface.withOpacity(0.6),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Section Conseils / Astuces
                          _buildAccordion(
                            context, colors,
                            title: "Comment faire ?",
                            icon: Icons.list_alt,
                            initiallyExpanded: true,
                            content: Column(
                              children: widget.action.tips.map((t) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_circle, color: colors.primary, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(t, style: TextStyle(color: colors.onSurface))),
                                  ],
                                ),
                              )).toList(),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Section Impact écologique
                          _buildAccordion(
                            context, colors,
                            title: "Pourquoi c'est important ?",
                            icon: Icons.lightbulb_outline,
                            initiallyExpanded: false,
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cette action permet d'économiser environ ${widget.action.co2Saved} de CO2.",
                                  style: TextStyle(color: colors.onSurface, height: 1.5),
                                ),
                                const SizedBox(height: 15),

                                // Preuve sociale (nombre de participants)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors.primary.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: colors.primary.withOpacity(0.1)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.groups, color: colors.primary, size: 20),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          "100 personnes ont déjà complété cette action !",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Source des données
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colors.onSurface.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 14, color: colors.onSurface.withOpacity(0.5)),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Source : Base Empreinte® ADEME",
                                        style: TextStyle(fontSize: 11, color: colors.onSurface.withOpacity(0.6), fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bouton pour fermer la modale
                Positioned(
                  top: 20,
                  left: 20,
                  child: SafeArea(child: _buildCloseButton(context)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Header avec dégradé et icône
  Widget _buildGreenHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
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
            child: Text(
              widget.action.categoryName.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Carte flottante affichant Points, CO2 et Difficulté
  Widget _buildFloatingStatsCard(ColorScheme colors, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outline),
        boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(Icons.bolt, "${widget.action.points} pts", "Gain", colors),
          Container(width: 1, height: 30, color: colors.outline),
          _statItem(Icons.cloud_outlined, widget.action.co2Saved, "CO2", colors),
          Container(width: 1, height: 30, color: colors.outline),
          _statItem(Icons.speed, widget.action.difficulty, "Niveau", colors),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String val, String label, ColorScheme colors) {
    return Column(children: [
      Icon(icon, color: colors.primary, size: 20),
      const SizedBox(height: 4),
      Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.onSurface)),
      Text(label, style: TextStyle(fontSize: 10, color: colors.onSurface.withOpacity(0.6))),
    ]);
  }

  // Système d'accordéon réutilisable
  Widget _buildAccordion(BuildContext context, ColorScheme colors, {required String title, required IconData icon, required bool initiallyExpanded, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colors.onSurface)),
          children: [Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), child: content)],
        ),
      ),
    );
  }

  // Barre fixe avec bouton d'action principal
  Widget _buildBottomBar(BuildContext context, OikosButtonTheme? buttonTheme, ColorScheme colors, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: buttonTheme?.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDarkMode ? null : [BoxShadow(color: (buttonTheme?.shadowColor ?? colors.primary).withOpacity(0.3), offset: const Offset(0, 4), blurRadius: 12)],
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

              const SizedBox(height: 8),

              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, size: 18, color: colors.onSurface.withOpacity(0.4)),
                label: Text(
                  "Cette action n'est pas pour moi",
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.5),
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: colors.onSurface.withOpacity(0.5),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
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