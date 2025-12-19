import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_cubit.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_objectifs.dart';
// Importe ta page d'objectifs ici
// import 'package:oikos/features/bilanCarbone/presentation/pages/personal_goal_page.dart';

class ChoixCategoriesPage extends StatefulWidget {
  const ChoixCategoriesPage({super.key});

  @override
  State<ChoixCategoriesPage> createState() => _ChoixCategoriesPageState();
}

class _ChoixCategoriesPageState extends State<ChoixCategoriesPage> {
  final Set<String> _selectedNames = {};

  void _toggleCategory(String name) {
    setState(() {
      if (_selectedNames.contains(name)) {
        _selectedNames.remove(name);
      } else {
        _selectedNames.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 💡 BlocListener pour gérer la navigation suite au changement d'état
    return BlocListener<BilanCubit, BilanState>(
      listener: (context, state) {
        if (state is BilanChoixObjectifs) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<BilanCubit>(),
                child: PersonalGoalPage(
                  objectifs: state.objectifs,
                ),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<BilanCubit, BilanState>(
        builder: (context, state) {
          List<CategorieEmpreinteEntity> categories = [];
          if (state is BilanChoixCategories) {
            categories = state.categories;
          }

         if (state is BilanLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.gradientGreenEnd),
                    SizedBox(height: 20),
                    Text("Calcul de ton empreinte..."),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              "Quels sujets t'intéressent ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.lightTextPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Sélectionne toutes les catégories qui te parlent pour recevoir des suggestions personnalisées.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.lightTextPrimary.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Info Box
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.lightIconPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.lightIconPrimary.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("💡 ", style: TextStyle(fontSize: 18)),
                                  Expanded(
                                    child: Text(
                                      "Tu ne recevras pas d'actions proposées dans les catégories non cochées.",
                                      style: TextStyle(
                                        color: AppColors.lightTextPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 35),

                            // Liste des catégories
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categories.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final cat = categories[index];
                                final isSelected = _selectedNames.contains(cat.nom);

                                return _CategoryCard(
                                  label: cat.nom,
                                  icon: cat.icone ?? '🌱',
                                  description: cat.description ?? '',
                                  isSelected: isSelected,
                                  onTap: () => _toggleCategory(cat.nom),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    // Footer avec le bouton adapté
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GradientButton(
                        label: _selectedNames.isNotEmpty
                            ? "Continuer avec ${_selectedNames.length} ${_selectedNames.length == 1 ? 'catégorie' : 'catégories'}"
                            : "Toutes les catégories m'intéressent",
                        onPressed: () {
                          // Récupération des entités sélectionnées
                          final finalSelection = _selectedNames.isEmpty 
                              ? categories 
                              : categories.where((c) => _selectedNames.contains(c.nom)).toList();
                          
                          // 💡 On notifie le Cubit. Le Cubit va enregistrer 
                          // PUIS émettre BilanChoixObjectifs, ce qui déclenchera le Listener au-dessus.
                          context.read<BilanCubit>().setSelectedCategories(finalSelection);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget de carte (inchangé par rapport à ta version, juste pour la complétude)
class _CategoryCard extends StatelessWidget {
  final String label;
  final String icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.lightIconPrimary : AppColors.lightBorder,
            width: 2,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart.withOpacity(0.15),
                    AppColors.gradientGreenEnd.withOpacity(0.15),
                  ],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? null : const Color(0xFFF5F5F5),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.lightTextPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.lightTextPrimary.withOpacity(0.5),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.lightIconPrimary, size: 24),
          ],
        ),
      ),
    );
  }
}