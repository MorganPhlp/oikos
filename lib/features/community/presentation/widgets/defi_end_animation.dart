import 'package:flutter/material.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/presentation/widgets/community_avatar.dart';

class DefiEndAnimation extends StatefulWidget {
  final DefiEntity defi;

  const DefiEndAnimation({super.key, required this.defi});

  @override
  State<DefiEndAnimation> createState() => _DefiEndAnimationState();
}

class _DefiEndAnimationState extends State<DefiEndAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animations
  late Animation<double> fadeEntry; // Entrée du widget
  late Animation<double> fadeLoser; // Disparition du perdant
  late Animation<double> scaleWinner; // Zoom du gagnant
  late Animation<double> scaleLoser; // Rétrécissement du perdant
  late Animation<double> moveWinner; // Glissement vers le centre
  late Animation<double> fadeText; // Apparition du nom du vainqueur

  late bool isWinnerLeft;

  @override
  void initState() {
    super.initState();
    isWinnerLeft =
        widget.defi.gagnantCode == widget.defi.communauteDemandeurCode;

    // Durée ralentie à 4 secondes pour bien décomposer les étapes
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // 1. Entrée du widget en fondu (0.0 à 0.5s environ)
    fadeEntry = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
      ),
    );

    // 2. Le perdant s'efface (0.6s à 1.8s)
    fadeLoser = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.45, curve: Curves.easeIn),
      ),
    );

    scaleLoser = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.45)),
    );

    // 3. Le gagnant glisse vers le centre (1.8s à 3.4s)
    moveWinner = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.easeInOutBack),
      ),
    );

    // 4. Le gagnant grandit (2.0s à 4.0s)
    scaleWinner = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 1.0, curve: Curves.elasticOut),
      ),
    );

    // 5. Texte final en fondu (fin de l'animation)
    fadeText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String winnerName = isWinnerLeft
        ? widget.defi.nomCommu1
        : widget.defi.nomCommu2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Opacity(
            opacity: fadeEntry.value, // Fondu d'entrée global
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "DÉFI TERMINÉ",
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 2,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nom de l'action

                  // Nom de l'action
                  Text(
                    widget.defi.action?.title ?? "Action communautaire",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Contre ${widget.defi.nomCommu2}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildAnimationContent(),
                  const SizedBox(height: 40),
                  // Nom du vainqueur avec son propre fondu
                  Opacity(
                    opacity: fadeText.value,
                    child: Column(
                      children: [
                        Text(
                          "VAINQUEUR",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          winnerName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimationContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double startOffset = width * 0.28;

        return SizedBox(
          height: 120,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- PERDANT ---
              Transform.translate(
                offset: Offset(isWinnerLeft ? startOffset : -startOffset, 0),
                child: Opacity(
                  opacity: fadeLoser.value,
                  child: Transform.scale(
                    scale: scaleLoser.value,
                    child: _buildAvatar(context, !isWinnerLeft),
                  ),
                ),
              ),
              // --- GAGNANT ---
              Transform.translate(
                offset: Offset(
                  isWinnerLeft
                      ? -startOffset * moveWinner.value
                      : startOffset * moveWinner.value,
                  0,
                ),
                child: Transform.scale(
                  scale: scaleWinner.value,
                  child: _buildAvatar(context, isWinnerLeft),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context, bool isFirst) {
    final theme = Theme.of(context);
    return CommunityAvatar(
      url: isFirst ? widget.defi.logoUrl1 : widget.defi.logoUrl2,
      name: isFirst ? widget.defi.nomCommu1 : widget.defi.nomCommu2,
      color: isFirst ? theme.colorScheme.primary : theme.colorScheme.secondary,
    );
  }
}
