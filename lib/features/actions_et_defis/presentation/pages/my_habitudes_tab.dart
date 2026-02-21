import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/habitudes_cubit.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/habitudes_state.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/habitude_card.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/help_button.dart';

class MyHabitudesTab extends StatelessWidget {
  const MyHabitudesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<HabitudeCubit, HabitudeState>(
      builder: (BuildContext context, HabitudeState state) {
        if (state is HabitudeLoaded) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: state.habitudes.length,
                      itemBuilder: (context, index) {
                        return HabitudeCard(habitude: state.habitudes[index]);
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 15,
                child: HelpButton(child: _buildInfoText(context)),
              ),
            ],
          );
        }
        if (state is HabitudeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HabitudeError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildInfoText(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logos/oikos_home.png', width: 28),
            Flexible(
              child: Text(
                "Tes habitudes Oikos",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset('assets/logos/oikos_home.png', width: 28),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          "Ici tu vois les actions qui font déjà partie de ton quotidien. "
          "Elles te rapportent des points automatiquement selon leur fréquence.",
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: colorScheme.onSecondaryContainer.withValues(alpha: 0.85),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: colorScheme.primary),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  "Tu peux retirer une action de ton mode de vie à tout moment.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
