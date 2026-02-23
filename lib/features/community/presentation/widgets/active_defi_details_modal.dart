import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../../data/models/defi_model.dart';
import '../../data/datasources/community_remote_datasource.dart';

class ActiveDefiDetailsModal extends StatefulWidget {
  final DefiModel defi;
  final String communityCode;

  const ActiveDefiDetailsModal({
    Key? key,
    required this.defi,
    required this.communityCode,
  }) : super(key: key);

  @override
  State<ActiveDefiDetailsModal> createState() => _ActiveDefiDetailsModalState();
}

class _ActiveDefiDetailsModalState extends State<ActiveDefiDetailsModal> {
  bool _isLoading = true;
  bool _hasValidatedToday = false;
  late CommunityRemoteDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    // Initialisation de la datasource avec le client Supabase
    _dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    _checkValidationStatus();
  }

  Future<void> _checkValidationStatus() async {
    try {
      final hasValidated = await _dataSource.checkIfDefiValidatedToday(widget.defi.id);
      if (mounted) {
        setState(() {
          _hasValidatedToday = hasValidated;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _validateAction() async {
    setState(() => _isLoading = true);
    try {
      // On utilise ici les arguments NOMMÉS car ta DataSource les exige (required)
      await _dataSource.validateDefiAction(
        defiId: widget.defi.id, 
        communityCode: widget.communityCode, 
        xpGain: widget.defi.xpGain,
      );
      
      if (mounted) {
        setState(() {
          _hasValidatedToday = true;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Action validée ! +${widget.defi.xpGain} XP pour ta communauté 🚀"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.pop(context, true);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la validation"), 
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de drag du modal (adaptative)
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Header : Icône + Titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.defi.title, 
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    Text(
                      widget.defi.category, 
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            "À faire", 
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          Text(
            widget.defi.description.isNotEmpty 
                ? widget.defi.description 
                : "Participe à ce défi pour faire gagner des points à ta communauté. Valide ton action pour marquer des points !", 
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)
          ),
          
          const SizedBox(height: 32),

          // Bouton de validation
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasValidatedToday 
                    ? (isDark ? Colors.white10 : Colors.grey[200]) 
                    : AppColors.lightPrimary,
                foregroundColor: _hasValidatedToday 
                    ? (isDark ? Colors.white38 : Colors.grey[600]) 
                    : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: (_isLoading || _hasValidatedToday) ? null : _validateAction,
              child: _isLoading 
                ? const SizedBox(
                    height: 24, 
                    width: 24, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5, 
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)
                    )
                  )
                : Text(
                    _hasValidatedToday 
                        ? "Déjà validé aujourd'hui ✅" 
                        : "Valider mon action (+${widget.defi.xpGain} XP)", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
            ),
          ),
          // Petit texte informatif sous le bouton
          if (!_hasValidatedToday && !_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Tu peux valider cette action une fois par jour",
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}