import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/loader.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/profile/presentation/bloc/interests_cubit.dart';
import 'package:oikos/features/profile/presentation/bloc/interests_state.dart';
import 'package:oikos/init_dependencies.dart';

class InterestsModal extends StatelessWidget {
  const InterestsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<InterestsCubit>()..loadInterests(),
      child: const _InterestsModalContent(),
    );
  }
}

class _InterestsModalContent extends StatelessWidget {
  const _InterestsModalContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de drag
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Centres d\'intérêt',
            style: AppTypography.h2.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionne les thématiques qui te tiennent à cœur pour tes défis.',
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: BlocConsumer<InterestsCubit, InterestsState>(
              listener: (context, state) {
                if (state is InterestsSaved) {
                  context.pop();
                }
                if (state is InterestsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is InterestsLoading) {
                  return const Center(child: Loader());
                }

                if (state is InterestsLoaded) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1, // Un peu plus carré pour la grille
                    ),
                    itemCount: state.allCategories.length,
                    itemBuilder: (context, index) {
                      final category = state.allCategories[index];
                      final isSelected = state.selectedCategories
                          .any((c) => c.nom == category.nom);

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<InterestsCubit>()
                              .toggleCategory(category);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.lightIconPrimary
                                  : colorScheme.outline.withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            gradient: isSelected
                                ? LinearGradient(
                              colors: [
                                AppColors.gradientGreenStart
                                    .withValues(alpha: 0.15),
                                AppColors.gradientGreenEnd
                                    .withValues(alpha: 0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Cercle avec l'Emoji
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? null
                                      : colorScheme.surface
                                      .withValues(alpha: 0.5),
                                  gradient: isSelected
                                      ? const LinearGradient(
                                    colors: [
                                      AppColors.gradientGreenStart,
                                      AppColors.gradientGreenEnd,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  category.icone, // L'émoji depuis la BDD
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                category.nom,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.body.copyWith(
                                  color: isSelected
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),

          const SizedBox(height: 16),

          // Bouton Valider
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<InterestsCubit>().saveInterests();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Enregistrer',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}