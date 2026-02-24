import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/action_remote_data_source.dart';
import '../../data/repositories/action_repository_impl.dart';
import '../../domain/entities/action_entity.dart';
import '../bloc/actions_bloc.dart';
import '../widgets/action_card.dart';
import '../widgets/action_detail_modal.dart';
import '../../../../../core/theme/oikos_button_theme.dart';

class ActionsCataloguePage extends StatefulWidget {
  const ActionsCataloguePage({super.key});

  @override
  State<ActionsCataloguePage> createState() => _ActionsCataloguePageState();
}

class _ActionsCataloguePageState extends State<ActionsCataloguePage> {
  final TextEditingController _searchController = TextEditingController();

  late final String userId;
  late final ActionRepositoryImpl repo;

  // Choix des filtres
  String selectedCategory = "Toutes";
  String selectedFrequency = "Toutes";
  String searchQuery = "";

  // Pour afficher les bons noms de fréquence
  String _getFreqLabel(String freq) {
    if (freq == "Toutes") return "Toutes";
    switch (freq.toLowerCase().trim()) {
      case 'journalier':
      case 'quotidien':
      case 'quotidienne':
        return 'Quotidien';
      case 'hebdomadaire':
      case 'hebdo':
        return 'Hebdo';
      case 'mensuel':
      case 'mensuelle':
        return 'Mensuel';
      case 'unique':
      case 'one shot':
      case 'bonus':
        return 'One Shot';
      default:
        return freq[0].toUpperCase() + freq.substring(1).toLowerCase();
    }
  }

  @override
  void initState() {
    super.initState();
    // Connexion à la base de données
    final supabase = Supabase.instance.client;
    userId = supabase.auth.currentUser!.id;
    final dataSource = ActionRemoteDataSourceImpl(supabase);
    repo = ActionRepositoryImpl(dataSource);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionsBloc(repository: repo)..add(LoadAllDataEvent(userId)),
      child: Builder(
          builder: (blocContext) {
            return Column(
              children: [
                Expanded(
                  child: BlocBuilder<ActionsBloc, ActionsState>(
                    builder: (context, state) {
                      if (state is ActionsLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }
                      if (state is ActionsLoaded) {
                        return _buildCatalogueList(blocContext, state.catalogue, repo, userId);
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            );
          }
      ),
    );
  }

  Widget _buildCatalogueList(
      BuildContext context,
      List<ActionEntity> catalogue,
      ActionRepositoryImpl repo,
      String userId,
      ) {
    final colors = Theme.of(context).colorScheme;

    // Récupère les catégories et fréquences de la liste
    final List<String> categoriesDisponibles = catalogue.map((e) => e.categoryName.trim()).toSet().toList();
    final List<String> frequencesDisponibles = catalogue.map((e) => e.frequency.trim()).toSet().toList();

    // Filtre la liste selon la recherche et les catégories
    final displayList = catalogue.where((action) {
      if (selectedCategory != "Toutes" && action.categoryName.trim().toLowerCase() != selectedCategory.trim().toLowerCase()) return false;
      if (selectedFrequency != "Toutes" && action.frequency.trim().toLowerCase() != selectedFrequency.trim().toLowerCase()) return false;

      if (searchQuery.isNotEmpty) {
        final match = action.title.toLowerCase().contains(searchQuery.toLowerCase());
        if (!match) return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => searchQuery = val),
            decoration: InputDecoration(
              hintText: "Rechercher une action...",
              prefixIcon: Icon(Icons.search, color: colors.primary),
              suffixIcon: IconButton(
                icon: Icon(Icons.tune, color: colors.primary),
                onPressed: () => _showFilterModal(context, categoriesDisponibles, frequencesDisponibles),
              ),
            ),
          ),
        ),

        if (selectedCategory != "Toutes" || selectedFrequency != "Toutes")
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (selectedCategory != "Toutes")
                  _buildActiveFilterChip(selectedCategory, () => setState(() => selectedCategory = "Toutes")),
                if (selectedFrequency != "Toutes")
                  _buildActiveFilterChip(_getFreqLabel(selectedFrequency), () => setState(() => selectedFrequency = "Toutes")),
              ],
            ),
          ),

        SizedBox(height: (selectedCategory != "Toutes" || selectedFrequency != "Toutes") ? 10 : 15),

        Expanded(
          child: displayList.isEmpty
              ? const Center(child: Text("Aucune action trouvée avec ces filtres"))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          await repo.joinChallenge(userId, action.id, freq);
                          if (!context.mounted) return;

                          context.read<ActionsBloc>().add(LoadAllDataEvent(userId));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text("Action ajoutée !"), backgroundColor: colors.primary),
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          // Gestion des erreurs (déjà rejoint ou limite atteinte)
                          String messageErreur = "Une erreur s'est produite.";
                          if (e.toString().contains("ALREADY_JOINED")) {
                            messageErreur = "Tu as déjà rejoint ce défi !";
                          } else if (e.toString().contains("LIMIT_REACHED")) {
                            messageErreur = "Limite atteinte pour ce type de défi.";
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(messageErreur), backgroundColor: colors.error),
                          );
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

  void _showFilterModal(BuildContext context, List<String> categories, List<String> frequences) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Filtres", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.onSurface)),
                        IconButton(icon: Icon(Icons.close, color: colors.onSurface), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text("Catégories", style: TextStyle(fontWeight: FontWeight.bold, color: colors.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ["Toutes", ...categories].map((cat) {
                        return _buildModalChip(
                          label: cat,
                          isSelected: selectedCategory == cat,
                          onTap: () {
                            setModalState(() => selectedCategory = cat);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 25),

                    Text("Fréquences", style: TextStyle(fontWeight: FontWeight.bold, color: colors.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ["Toutes", ...frequences].map((freq) {
                        return _buildModalChip(
                          label: _getFreqLabel(freq),
                          isSelected: selectedFrequency == freq,
                          onTap: () {
                            setModalState(() => selectedFrequency = freq);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    final colors = Theme.of(context).colorScheme;
    final buttonTheme = Theme.of(context).extension<OikosButtonTheme>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? buttonTheme?.primaryGradient : null,
          color: isSelected ? null : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : colors.outline),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colors.onPrimary : colors.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onClear) {
    final colors = Theme.of(context).colorScheme;
    final buttonTheme = Theme.of(context).extension<OikosButtonTheme>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: buttonTheme?.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: colors.onPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, size: 14, color: colors.onPrimary.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}