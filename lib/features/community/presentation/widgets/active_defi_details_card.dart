import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/presentation/bloc/defis_cubit.dart';
import 'package:oikos/features/community/presentation/bloc/defis_state.dart';
import 'package:oikos/features/community/presentation/widgets/animated_progress_bar.dart';

class ActiveDefiDetailsCard extends StatefulWidget {
  final DefiEntity defi;
  final VoidCallback onValidate;

  const ActiveDefiDetailsCard({
    super.key,
    required this.defi,
    required this.onValidate,
  });

  @override
  State<ActiveDefiDetailsCard> createState() => _ActiveDefiDetailsCardState();
}

class _ActiveDefiDetailsCardState extends State<ActiveDefiDetailsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(
      widget.defi.categorieNom,
    );

    return BlocBuilder<DefisCubit, DefisState>(
      builder: (context, state) {
        DefiEntity currentDefi = widget.defi;
        bool hasParticipated = false;

        if (state is DefisLoaded) {
          final index = state.defis.indexWhere((d) => d.id == widget.defi.id);
          if (index != -1) currentDefi = state.defis[index];
          hasParticipated =
              state.participations?.any((p) => p.defiId == widget.defi.id) ??
              false;
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: Hero(
                  tag: widget.defi.id,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: categoryColor.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeader(currentDefi, categoryColor, theme),
                            _buildDuelSection(currentDefi, categoryColor),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    children: [
                                      _buildTitleAndDescription(
                                        currentDefi,
                                        theme,
                                      ),
                                      const SizedBox(height: 24),
                                      const DecorativeSeparator(),
                                      const SizedBox(height: 16),
                                      _buildProgressSection(
                                        currentDefi.nomCommu1,
                                        currentDefi.progress1,
                                        categoryColor,
                                      ),
                                      const SizedBox(height: 20),
                                      _buildProgressSection(
                                        currentDefi.nomCommu2,
                                        currentDefi.progress2,
                                        categoryColor,
                                      ),
                                      const SizedBox(height: 30),
                                      _buildActionZone(
                                        hasParticipated,
                                        state,
                                        widget.onValidate,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(String name, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => Text(
                "${(value * 100).toInt()}%",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedProgressBar(progress: progress, color: color),
      ],
    );
  }

  Widget _buildActionZone(
    bool hasParticipated,
    DefisState state,
    VoidCallback onValidate,
  ) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: hasParticipated
            ? const Column(
                key: ValueKey('success'),
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 4),
                  Text(
                    "Défi relevé !",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : GradientButton(
                key: const ValueKey('button'),
                label: 'Valider le défi',
                onPressed: (state is DefisLoading) ? null : onValidate,
              ),
      ),
    );
  }

  Widget _buildHeader(DefiEntity defi, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(defi.action?.icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                defi.categorieNom.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          _buildLiveBadge(color),
        ],
      ),
    );
  }

  Widget _buildDuelSection(DefiEntity defi, Color color) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            color: color.withValues(alpha: 0.2),
          ),
          Positioned(
            left: 20,
            child: _buildAvatar(defi.logoUrl1, defi.nomCommu1, color),
          ),
          Positioned(
            right: 20,
            child: _buildAvatar(defi.logoUrl2, defi.nomCommu2, color),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              "VS",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url, String name, Color color) {
    return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Text(
              name.isNotEmpty ? name[0] : "?",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 4, backgroundColor: Colors.red),
          const SizedBox(width: 6),
          Text(
            "EN COURS",
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndDescription(DefiEntity defi, ThemeData theme) {
    return Column(
      children: [
        Text(
          defi.displayTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          defi.action?.description ?? "Pas de description.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
