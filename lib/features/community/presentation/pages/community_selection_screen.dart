import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';

class CommunitySelectionScreen extends StatefulWidget {
  final String entrepriseId;
  final String myCommunityCode;

  const CommunitySelectionScreen({Key? key, required this.entrepriseId, required this.myCommunityCode}) : super(key: key);

  @override
  State<CommunitySelectionScreen> createState() => _CommunitySelectionScreenState();
}

class _CommunitySelectionScreenState extends State<CommunitySelectionScreen> {
  List<LeaderboardEntryModel> _communities = [];
  List<LeaderboardEntryModel> _filteredCommunities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    final ds = CommunityRemoteDataSource(Supabase.instance.client);
    final results = await ds.getAdversaryCommunities(widget.entrepriseId, widget.myCommunityCode);
    setState(() {
      _communities = results;
      _filteredCommunities = results;
      _isLoading = false;
    });
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredCommunities = _communities
          .where((c) => c.label.toLowerCase().contains(query.toLowerCase()))
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                      leading: OikosAvatar(avatarUrl: community.avatarUrl, label: community.label),
                      title: Text(community.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${community.membersCount} membres"),
                      trailing: const Icon(Icons.group_add, color: Colors.green),
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