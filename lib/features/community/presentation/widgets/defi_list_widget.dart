import 'package:flutter/material.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/presentation/widgets/active_defi.dart';

class DefiListWidget extends StatefulWidget {
  final List<DefiEntity> defis;
  final Function(String defiId) onValidate;

  const DefiListWidget({
    super.key,
    required this.defis,
    required this.onValidate,
  });

  @override
  State<DefiListWidget> createState() => _DefiListWidgetState();
}

class _DefiListWidgetState extends State<DefiListWidget> {
  late PageController _controller;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    // 0.80 permet de voir les bords des cartes adjacentes
    _controller = PageController(viewportFraction: 0.80);
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeDefis = widget.defis.where((d) => d.status == 'ACTIF').toList();
    if (activeDefis.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            clipBehavior: Clip.none,
            itemCount: activeDefis.length,
            itemBuilder: (context, index) {
              double relativePosition = index - _currentPage;

              // Transformation matricielle pour l'effet "Cylindre"
              final double scaleFactor = (1 - (relativePosition.abs() * 0.15))
                  .clamp(0.0, 1.0);

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective 3D
                  ..setEntry(0, 0, scaleFactor) // Échelle sur l'axe X
                  ..setEntry(1, 1, scaleFactor) // Échelle sur l'axe Y
                  ..rotateY(relativePosition * 0.25), // Rotation cylindrique
                alignment: relativePosition > 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Opacity(
                  opacity: (1 - (relativePosition.abs() * 0.4)).clamp(0.0, 1.0),
                  child: ActiveDefiCard(
                    defi: activeDefis[index],
                    onValidate: () => widget.onValidate(activeDefis[index].id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
