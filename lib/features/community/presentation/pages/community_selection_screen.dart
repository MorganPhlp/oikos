import 'package:flutter/material.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';

import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';

class CommunitySelectionScreen extends StatefulWidget {
  final List<CommunityEntity> communities;
  const CommunitySelectionScreen({super.key, required this.communities});

  @override
  State<CommunitySelectionScreen> createState() =>
      _CommunitySelectionScreenState();
}

class _CommunitySelectionScreenState extends State<CommunitySelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Initialise la liste filtrée avec toutes les communautés au démarrage
    _filteredCommunities = widget.communities;
  }

  late List<CommunityEntity> _filteredCommunities;
  final bool _isLoading = false;

  void _filterSearch(String query) {
    setState(() {
      _filteredCommunities = widget.communities
          .where((c) => c.nom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choisir un adversaire")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: "Rechercher une communauté...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredCommunities.length,
                    itemBuilder: (context, index) {
                      final community = _filteredCommunities[index];
                      return ListTile(
                        leading: OikosAvatar(
                          avatarUrl: community.logoUrl,
                          label: community.nom,
                        ),
                        title: Text(
                          community.nom,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${community.membersCount} membre(s)"),
                        trailing: const Icon(
                          Icons.group_add,
                          color: Colors.green,
                        ),
                        onTap: () => Navigator.pop(context, community),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
