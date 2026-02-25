import 'package:flutter/material.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';
import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';
import 'package:oikos/features/community/presentation/widgets/pending_defi_card.dart';

class PendingDefisWidget extends StatefulWidget {
  final List<DefiEntity> defis;
  final List<VoteDefiEntity> votes;
  final List<ParticipationDefiEntity> participations;
  final Function(String defiId, bool isFavorable)? onVote;

  const PendingDefisWidget({
    super.key,
    required this.defis,
    required this.votes,
    required this.participations,
    this.onVote,
  });

  @override
  State<PendingDefisWidget> createState() => _PendingDefisWidgetState();
}

class _PendingDefisWidgetState extends State<PendingDefisWidget> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    // viewportFraction à 0.85 pour voir un peu les cartes d'à côté sans transform
    _controller = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defis.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Votes en cours (${widget.defis.length})",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 270,
          child: PageView.builder(
            controller: _controller,
            // padEnds: false si tu veux que la première carte soit collée à gauche
            padEnds: true,
            itemCount: widget.defis.length,
            itemBuilder: (context, index) {
              final defi = widget.defis[index];
              final bool alreadyVoted = widget.votes.hasVotedForDefi(defi.id);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: PendingDefiCard(
                  defi: defi,
                  onVote: widget.onVote,
                  hasVoted: alreadyVoted,
                  voteValue: alreadyVoted
                      ? widget.votes
                            .firstWhere((v) => v.defiId == defi.id)
                            .voteValue
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
