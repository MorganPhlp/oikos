import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/action_remote_data_source.dart';
import '../../data/repositories/action_repository_impl.dart';
import '../../domain/entities/action_entity.dart';
import '../bloc/actions_bloc.dart';
import '../widgets/action_card.dart';
import '../widgets/action_detail_modal.dart';
import '../widgets/actions_header.dart'; // <--- Import du Header Vert
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/oikos_button_theme.dart';

class ActionsCataloguePage extends StatefulWidget {
  const ActionsCataloguePage({super.key});

  @override
  State<ActionsCataloguePage> createState() => _ActionsCataloguePageState();
}

class _ActionsCataloguePageState extends State<ActionsCataloguePage> {
  String selectedCategory = "Toutes";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Dépendances
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    final dataSource = ActionRemoteDataSourceImpl(supabase);
    final repo = ActionRepositoryImpl(dataSource);

    return BlocProvider(
      create: (_) =>
          ActionsBloc(repository: repo)..add(LoadAllDataEvent(userId)),
      child: Column(
        children: [
          // 1. LE HEADER VERT (Profil, Titre, Notif)

          // 2. LE CONTENU (Recherche + Filtres + Liste)
          Expanded(
            child: BlocBuilder<ActionsBloc, ActionsState>(
              builder: (context, state) {
                if (state is ActionsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightPrimary,
                    ),
                  );
                }
                if (state is ActionsLoaded) {
                  return _buildCatalogueList(
                    context,
                    state.catalogue,
                    repo,
                    userId,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogueList(
    BuildContext context,
    List<ActionEntity> catalogue,
    ActionRepositoryImpl repo,
    String userId,
  ) {
    final Set<String> categoriesDisponibles = catalogue
        .map((e) => e.categoryName)
        .toSet();
    List<String> filtres = ["Toutes", ...categoriesDisponibles];

    final displayList = catalogue.where((action) {
      if (selectedCategory != "Toutes" &&
          action.categoryName != selectedCategory)
        return false;
      if (searchQuery.isNotEmpty) {
        final match = action.title.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        if (!match) return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        const SizedBox(height: 20),

        // BARRE DE RECHERCHE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.lightInputBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: const InputDecoration(
                hintText: "Rechercher une action...",
                hintStyle: TextStyle(color: AppColors.lightMutedForeground),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: AppColors.lightIconPrimary),
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // FILTRES
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: filtres
                .map(
                  (cat) =>
                      _buildFilterChip(context, cat, selectedCategory == cat),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: 10),

        // LISTE
        Expanded(
          child: displayList.isEmpty
              ? const Center(child: Text("Aucune action trouvée"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final action = displayList[index];
                    return ActionCard(
                      action: action,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ActionDetailModal(
                            action: action,
                            onJoin: (freq) async {
                              Navigator.pop(context);
                              try {
                                await repo.joinChallenge(
                                  userId,
                                  action.id,
                                  freq,
                                );

                                context.read<ActionsBloc>().add(
                                  LoadAllDataEvent(userId),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Action ajoutée !"),
                                    backgroundColor: AppColors.lightPrimary,
                                  ),
                                );
                              } catch (e) {
                                /*...*/
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final buttonTheme = Theme.of(context).extension<OikosButtonTheme>();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => selectedCategory = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? buttonTheme?.primaryGradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : AppColors.lightInputBorder,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: buttonTheme?.shadowColor ?? Colors.transparent,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.lightTextPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
