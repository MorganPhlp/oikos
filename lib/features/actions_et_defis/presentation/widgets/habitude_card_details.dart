import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';

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
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
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
              child: Container(color: Colors.transparent),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Hero(
                tag: habitude.action.title,
                child: Material(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      habitude.action.icon,
                                      color: categoryColor,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habitude.action.categoryName
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: categoryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            habitude.action.title,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                  ],
                                ),
                                FadeTransition(
                                  opacity: _contentAnimation!,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 24),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          habitude.action.description,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(height: 1.5),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
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
                          Positioned(
                            top: 24,
                            right: 24,
                            child: FadeTransition(
                              opacity: _contentAnimation!,
                              child: GestureDetector(
                                onTap: () => context.goNamed(
                                  'catalogue',
                                  queryParameters: {
                                    'actionId': habitude.action.id,
                                  },
                                ),
                                child: Text(
                                  "Voir dans le catalogue",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: categoryColor,
                                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Color color) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: theme.colorScheme.secondary,
          elevation: 0,
        ),
        onPressed: () {},
        child: const Text(
          "Je ne veux plus de cette habitude",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
