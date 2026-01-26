import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/widgets/loader.dart';
import 'package:oikos/core/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_state.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_event.dart';

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
    return BlocListener<BilanResultatBloc, ResultatState>(
      listener: (context, state) {
        // Navigation vers l'étape suivante (objectifs)
        if (state is ResultatChoixObjectifs) {
          Navigator.of(context).pushNamed('objectifs');
        }
      },
      child: BlocBuilder<BilanResultatBloc, ResultatState>(
        builder: (context, state) {
          List<CategorieEmpreinteEntity> categories = [];

          // On récupère les catégories depuis l'état du bloc
          if (state is ResultatChoixCategories) {
            categories = state.categories;
          }

          if (state is ResultatLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loader(),
                    SizedBox(height: 20),
                    Text("Calcul de ton empreinte..."),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => {
                  context.read<QuestionnaireBloc>().add(
                    RetourVersQuestionnaireEvent(),
                  ),
                  Navigator.of(context).pop(),
                },
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.012,
                            ),
                            Text(
                              "Quels sujets t'intéressent ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize:
                                    MediaQuery.of(context).size.width < 360
                                    ? 22
                                    : MediaQuery.of(context).size.width * 0.065,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            Text(
                              "Sélectionne toutes les catégories qui te parlent pour recevoir des suggestions personnalisées.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha:0.7),
                                fontSize:
                                    MediaQuery.of(context).size.width < 360
                                    ? 14
                                    : MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.024,
                            ),
                            _buildInfoBox(context),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                            ),
                            _buildCategoryList(categories, context),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildFooter(categories, context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: AppColors.lightIconPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(
          color: AppColors.lightIconPrimary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💡 ",
            style: TextStyle(fontSize: isSmallScreen ? 16 : size.width * 0.045),
          ),
          Expanded(
            child: Text(
              "Tu ne recevras pas d'actions proposées dans les catégories non cochées.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: isSmallScreen ? 13 : size.width * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    List<CategorieEmpreinteEntity> categories,
    BuildContext context,
  ) {
    final spacing = MediaQuery.of(context).size.height * 0.015;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder: (_, _) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedNames.contains(cat.nom);

        return _CategoryCard(
          label: cat.nom,
          icon: cat.icone,
          description: cat.description,
          isSelected: isSelected,
          onTap: () => _toggleCategory(cat.nom),
        );
      },
    );
  }

  Widget _buildFooter(
    List<CategorieEmpreinteEntity> categories,
    BuildContext context,
  ) {
    final verticalPadding = MediaQuery.of(context).size.height * 0.025;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: GradientButton(
        label: _selectedNames.isNotEmpty
            ? "Continuer avec ${_selectedNames.length} ${_selectedNames.length == 1 ? 'catégorie' : 'catégories'}"
            : "Toutes les catégories m'intéressent",
        onPressed: () {
          final finalSelection = _selectedNames.isEmpty
              ? categories
              : categories
                    .where((c) => _selectedNames.contains(c.nom))
                    .toList();

          // Adaptation : Utilisation de ValiderCategoriesEvent
          context.read<BilanResultatBloc>().add(
            ValiderCategoriesEvent(finalSelection),
          );
        },
      ),
    );
  }
}

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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final iconSize = size.width * 0.125;
    final padding = size.width * 0.04;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(size.width * 0.04),
          border: Border.all(
            color: isSelected
                ? AppColors.lightIconPrimary
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart.withValues(alpha: 0.15),
                    AppColors.gradientGreenEnd.withValues(alpha: 0.15),
                  ],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withValues(alpha: isSelected ? 0.08 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? null
                    : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
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
                icon,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : size.width * 0.06,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.037),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      fontSize: isSmallScreen ? 15 : size.width * 0.04,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: isSmallScreen ? 12 : size.width * 0.033,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.lightIconPrimary,
                size: isSmallScreen ? 20 : size.width * 0.06,
              ),
          ],
        ),
      ),
    );
  }
}
