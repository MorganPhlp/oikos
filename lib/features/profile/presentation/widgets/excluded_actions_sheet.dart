import 'package:flutter/material.dart';
import 'package:oikos/features/actions/domain/entities/excluded_preference.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';

class ExcludedActionsSheet extends StatefulWidget {
  const ExcludedActionsSheet({
    super.key,
    required this.repository,
    required this.userId,
  });
  final ActionRepository repository;
  final String userId;
  @override
  State<ExcludedActionsSheet> createState() => _ExcludedActionsSheetState();
}

class _ExcludedActionsSheetState extends State<ExcludedActionsSheet> {
  List<ExcludedPreference> _items = [];
  String? _error;
  bool _loading = true;
  ExcludedPreference? _restoring;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await widget.repository.getExcludedPreferences(
      widget.userId,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      result.fold((f) => _error = f.message, (items) => _items = items);
    });
  }

  Future<void> _restore(ExcludedPreference item) async {
    setState(() {
      _restoring = item;
      _error = null;
    });
    final result = await widget.repository.restoreExcludedPreference(
      widget.userId,
      item,
    );
    if (!mounted) return;
    setState(() {
      _restoring = null;
      result.fold((f) => _error = f.message, (_) => _items.remove(item));
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Actions écartées',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Rétablis une action, une catégorie ou un tag dans tes suggestions.',
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? const Center(child: Text('Aucune préférence écartée.'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text(item.label),
                        subtitle: Text(switch (item.kind) {
                          ExclusionKind.action => 'Action',
                          ExclusionKind.category => 'Catégorie',
                          ExclusionKind.tag => 'Tag',
                        }),
                        trailing: TextButton(
                          onPressed: _restoring == null
                              ? () => _restore(item)
                              : null,
                          child: Text(
                            _restoring == item ? 'Rétablissement…' : 'Rétablir',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
