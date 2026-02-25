import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/presentation/bloc/defis_cubit.dart';
import 'package:oikos/features/community/presentation/widgets/active_defi_details_card.dart';
import 'package:oikos/features/community/presentation/widgets/community_avatar.dart';

class ActiveDefiCard extends StatelessWidget {
  final DefiEntity defi;
  final VoidCallback onValidate;

  const ActiveDefiCard({
    super.key,
    required this.defi,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(defi.categorieNom);

    return Hero(
      tag: defi.id,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final defisCubit = context.read<DefisCubit>();
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black.withValues(alpha: 0.5),
                pageBuilder: (context, _, _) => BlocProvider.value(
                  value: defisCubit,
                  child: ActiveDefiDetailsCard(
                    defi: defi,
                    onValidate: onValidate,
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            defi.action?.icon,
                            color: categoryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            defi.categorieNom.toUpperCase(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: categoryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildLiveBadge(categoryColor),
                    ],
                  ),
                ),

                _buildDuelSection(context, categoryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDuelSection(BuildContext context, Color accentColor) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.1),
                  accentColor,
                  accentColor.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildCommunityInfo(
                  context,
                  defi.logoUrl1,
                  defi.nomCommu1,
                  accentColor,
                  CrossAxisAlignment.start,
                ),
              ),

              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                ),
                child: Text(
                  "VS",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Communauté 2
              Expanded(
                child: _buildCommunityInfo(
                  context,

                  defi.logoUrl2,
                  defi.nomCommu2,
                  accentColor,
                  CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityInfo(
    BuildContext context,
    String url,
    String name,
    Color color,
    CrossAxisAlignment alignment,
  ) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        CommunityAvatar(url: url, name: name, color: color),
        const SizedBox(height: 6),
        Text(
          name,
          textAlign: alignment == CrossAxisAlignment.start
              ? TextAlign.left
              : TextAlign.right,
          style: TextStyle(
            fontSize: 11,
            height: 1.2, // Ajuste l'interligne pour les noms sur 2 lignes
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 3, backgroundColor: Colors.red),
          const SizedBox(width: 4),
          Text(
            "EN COURS",
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
