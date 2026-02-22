import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/action_stats.dart';

class HabitudeCardDetails extends StatefulWidget {
  final HabitudeEntity habitude;
  const HabitudeCardDetails({super.key, required this.habitude});

  @override
  State<HabitudeCardDetails> createState() => _HabitudeCardDetailsState();
}

class _HabitudeCardDetailsState extends State<HabitudeCardDetails> {
  HabitudeEntity get habitude => widget.habitude;

  Animation<double>? _routeAnimation;
  Animation<double>? _contentAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animation = ModalRoute.of(context)?.animation;
    if (animation != null) {
      _routeAnimation = animation;
      _contentAnimation = CurvedAnimation(
        parent: _routeAnimation!,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = theme.extension<ActionCardTheme>()!.getCategoryColor(
      habitude.action.categoryName,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.black.withValues(alpha: 0.1)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Hero(
                tag: habitude.action.title,
                child: Material(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(28),
                  elevation: 12,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Icon(
                                    habitude.action.icon,
                                    color: categoryColor,
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  habitude.action.categoryName.toUpperCase(),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  habitude.action.title,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                ),

                                // Contenu animé
                                if (_contentAnimation != null)
                                  FadeTransition(
                                    opacity: _contentAnimation!,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        OikosActionStats(
                                          impactScore:
                                              habitude.action.impactScore,
                                          difficulty:
                                              habitude.action.difficulty,
                                          frequencyLabel:
                                              habitude.action.frequency,
                                        ),
                                        const SizedBox(height: 20),
                                        Divider(
                                          color: categoryColor.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          habitude.action.description,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                height: 1.6,
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                        const SizedBox(height: 40),
                                        _buildActionButton(
                                          context,
                                          categoryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          if (_contentAnimation != null)
                            Positioned(
                              top: 20,
                              right: 20,
                              child: FadeTransition(
                                opacity: _contentAnimation!,
                                child: IconButton(
                                  onPressed: () => context.goNamed(
                                    'catalogue',
                                    queryParameters: {
                                      'actionId': habitude.action.id,
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.open_in_new,
                                    size: 20,
                                    color: categoryColor,
                                  ),
                                  tooltip: "Voir dans le catalogue",
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
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Color color) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
        child: const Text(
          "Je ne veux plus de cette habitude",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
