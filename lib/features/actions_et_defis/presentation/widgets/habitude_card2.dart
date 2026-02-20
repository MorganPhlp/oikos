// import 'package:flutter/material.dart';
// import 'package:oikos/core/theme/action_card_theme.dart';
// import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';

// class HabitudeCard extends StatefulWidget {
//   final HabitudeEntity habitude;
//   const HabitudeCard({super.key, required this.habitude});

//   @override
//   State<HabitudeCard> createState() => _HabitudeCardState();
// }

// class _HabitudeCardState extends State<HabitudeCard> {
//   bool isFlipped = false;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final actionTheme = theme.extension<ActionCardTheme>()!;

//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0, end: isFlipped ? 1 : 0),
//       duration: const Duration(milliseconds: 500),
//       builder: (context, value, child) {
//         final angle = value * 3.1416;
//         final isBack = value > 0.5;

//         return Transform(
//           transform: Matrix4.identity()
//             ..setEntry(2, 3, 0.001)
//             ..rotateY(angle),
//           alignment: Alignment.center,
//           child: GestureDetector(
//             onTap: () => setState(() => isFlipped = !isFlipped),
//             child: Container(
//               width: 200,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: actionTheme.getCategoryColor('Habitude'),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                 child: isBack
//                     ? Transform(
//                         transform: Matrix4.identity()..rotateY(3.1416),
//                         alignment: Alignment.center,
//                         child: _buildBack(context),
//                       )
//                     : _buildFront(context),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFront(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       width: 200,
//       height: 120,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: theme.colorScheme.shadow.withValues(alpha: 0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           widget.habitude.action.title,
//           style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildBack(BuildContext context) {
//     final theme = Theme.of(context);
//     final themeAction = theme.extension<ActionCardTheme>()!;

//     return Container(
//       width: 200,
//       height: 120,
//       decoration: BoxDecoration(
//         color: themeAction
//             .getCategoryColor(widget.habitude.action.categoryName)
//             .withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: Text(
//           widget.habitude.action.description,
//           style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
