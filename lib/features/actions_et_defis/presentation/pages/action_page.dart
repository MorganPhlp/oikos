import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/action_remote_data_source.dart';
import '../../data/repositories/action_repository_impl.dart';
import '../../domain/entities/action_entity.dart';
import '../bloc/actions_bloc.dart';
import '../widgets/action_card.dart';
import '../widgets/action_detail_modal.dart';
import 'my_actions_tab.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  String selectedCategory = "Toutes";
  String searchQuery = ""; // <--- 1. VARIABLE POUR LA RECHERCHE

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = "5fa69d4d-94ec-49af-8495-65f6b39a96bb";
    final dataSource = ActionRemoteDataSourceImpl(supabase);
    final repo = ActionRepositoryImpl(dataSource);

    return BlocProvider(
      create: (_) => ActionsBloc(repository: repo)..add(LoadAllDataEvent(userId)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              // HEADER VERT (Inchangé)
              Container(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
                decoration: const BoxDecoration(
                  color: Color(0xFFA2D260),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.person, color: Colors.black87),
                        ),
                        const Column(
                          children: [
                            Text("Espace", style: TextStyle(fontSize: 14, color: Colors.black54)),
                            Text("Actions & Défis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ],
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.notifications_none, color: Colors.black87),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black45,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      tabs: [Tab(text: "CATALOGUE"), Tab(text: "MES ACTIONS")],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // CONTENU
              Expanded(
                child: BlocBuilder<ActionsBloc, ActionsState>(
                  builder: (context, state) {
                    if (state is ActionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ActionsError) {
                      return Center(child: Text("Erreur: ${state.message}"));
                    } else if (state is ActionsLoaded) {
                      return TabBarView(
                        children: [
                          _buildCatalogueTab(context, state.catalogue, repo, userId),
                          state.mesDefis.isEmpty
                              ? const Center(child: Text("Aucun défi en cours. Va dans le catalogue !"))
                              : MyActionsTab(
                            challenges: state.mesDefis,
                            onValidate: (actionId) async {
                              await repo.validateAction(userId, actionId, 10, 0.5);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Action validée ! Bravo ! 🎉"))
                              );
                            },
                            onDelete: (actionId) async {
                              await repo.removeChallenge(userId, actionId);
                              context.read<ActionsBloc>().add(LoadAllDataEvent(userId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Défi arrêté. À bientôt ! 👋"))
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogueTab(BuildContext context, List<ActionEntity> catalogue, ActionRepositoryImpl repo, String userId) {
    final Set<String> categoriesDisponibles = catalogue.map((e) => e.categoryName).toSet();
    List<String> filtres = ["Toutes", ...categoriesDisponibles];

    // 2. FILTRAGE COMPLET (Catégorie + Recherche)
    final displayList = catalogue.where((action) {
      // Filtre Catégorie
      if (selectedCategory != "Toutes" && action.categoryName != selectedCategory) {
        return false;
      }
      // Filtre Recherche ( <--- NOUVEAU )
      if (searchQuery.isNotEmpty) {
        final titleMatch = action.title.toLowerCase().contains(searchQuery.toLowerCase());
        final descMatch = action.description.toLowerCase().contains(searchQuery.toLowerCase());
        if (!titleMatch && !descMatch) return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        Container(
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            children: [
              // BARRE DE RECHERCHE CONNECTÉE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: TextField( // <--- 3. ON CONNECTE LE TEXTFIELD
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Met à jour la recherche quand on tape
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Rechercher une action...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: filtres.map((categorie) {
                    IconData? icon;
                    if (categorie.contains('Transport')) icon = Icons.directions_bus;
                    else if (categorie.contains('Alimentation')) icon = Icons.restaurant;
                    else if (categorie.contains('Eau')) icon = Icons.water_drop;
                    else if (categorie.contains('Numérique')) icon = Icons.computer;

                    return _buildFilterChip(categorie, selectedCategory == categorie, icon: icon);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

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
                          await repo.joinChallenge(userId, action.id, freq);

                          // ignore: use_build_context_synchronously
                          context.read<ActionsBloc>().add(LoadAllDataEvent(userId));

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Défi ajouté ! 🚀"), backgroundColor: Color(0xFF76B82A))
                          );
                        } catch (e) {
                          // GESTION DES ERREURS (Doublon + Limite)
                          String message = "Une erreur est survenue";
                          Color color = Colors.red;

                          if (e.toString().contains("LIMIT_REACHED")) {
                            message = "✋ Tu as déjà 5 défis en cours !";
                          } else if (e.toString().contains("ALREADY_JOINED")) { // <--- NOUVEAU CAS
                            message = "⚠️ Tu relèves déjà ce défi ! Regarde dans 'Mes Actions'";
                            color = Colors.orange;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message), backgroundColor: color)
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

  Widget _buildFilterChip(String label, bool isSelected, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        avatar: icon != null ? Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey) : null,
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = label;
          });
        },
        selectedColor: const Color(0xFF76B82A),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}