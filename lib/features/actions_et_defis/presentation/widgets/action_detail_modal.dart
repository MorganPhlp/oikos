import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';

class ActionDetailModal extends StatefulWidget {
  final ActionEntity action;
  final Function(String freq) onJoin;

  const ActionDetailModal({
    super.key,
    required this.action,
    required this.onJoin,
  });

  @override
  State<ActionDetailModal> createState() => _ActionDetailModalState();
}

class _ActionDetailModalState extends State<ActionDetailModal> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Stack(
            children: [
              ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  _buildGreenHeader(),
                  const SizedBox(height: 60),
                  _buildBodyContent(),
                  const SizedBox(height: 120), // Espace pour le bouton
                ],
              ),
              Positioned(
                top: 230,
                left: 20,
                right: 20,
                child: _buildFloatingStatsCard(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActionBar(),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- HEADER VERT ---
  Widget _buildGreenHeader() {
    return Container(
      height: 280,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA2D260), Color(0xFF76B82A)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.action.icon, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            widget.action.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderTag(widget.action.categoryName),
              const SizedBox(width: 8),
              _buildHeaderTag(_getFreqLabel(widget.action.frequency)), // Affiche la fréquence
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- STATS FLOTTANTES ---
  Widget _buildFloatingStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.cloud_off, widget.action.co2Saved, "CO₂ évité"),
          Container(height: 30, width: 1, color: Colors.grey[200]),
          _buildStatItem(Icons.bolt, "+${widget.action.points}", "Points"),
          Container(height: 30, width: 1, color: Colors.grey[200]),
          _buildStatItem(Icons.bar_chart, widget.action.difficulty, "Difficulté"),
        ],
      ),
    );
  }

  // --- CORPS DU TEXTE ---
  Widget _buildBodyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.action.description, style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5)),
          const SizedBox(height: 30),
          if (widget.action.tips.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Astuces :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                ...widget.action.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF76B82A), size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(tip, style: TextStyle(color: Colors.grey[800]))),
                    ],
                  ),
                )),
              ],
            ),
          const SizedBox(height: 20),
          Center(child: Text("Source : ADEME", style: TextStyle(color: Colors.grey[400], fontSize: 12))),
        ],
      ),
    );
  }

  // --- BARRE DU BAS SIMPLIFIÉE ---
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Info Fréquence
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF76B82A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Fréquence : ${_getFreqLabel(widget.action.frequency)}",
              style: const TextStyle(color: Color(0xFF76B82A), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),

          // BOUTON UNIQUE
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => widget.onJoin(widget.action.frequency), // On envoie la fréquence auto
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF76B82A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text(
                "Je relève le défi !",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("✕  Pas maintenant", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          )
        ],
      ),
    );
  }

  // Helpers
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, color: Colors.grey[400], size: 20),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
    ]);
  }

  Widget _buildHeaderTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  String _getFreqLabel(String freq) {
    switch (freq) {
      case 'journalier': return "Chaque jour";
      case 'hebdomadaire': return "Chaque semaine";
      case 'mensuel': return "Chaque mois";
      case 'unique': return "Une fois";
      default: return freq;
    }
  }
}