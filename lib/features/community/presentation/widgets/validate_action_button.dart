import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ValidateActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isValidated;
  const ValidateActionButton({
    super.key,
    this.onPressed,
    required this.isValidated,
  });

  @override
  State<ValidateActionButton> createState() => _ValidateActionButtonState();
}

class _ValidateActionButtonState extends State<ValidateActionButton> {
  late bool isValidated;

  @override
  void initState() {
    super.initState();
    isValidated = widget.isValidated;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),

      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    const double buttonHeight = 30.0;

    if (isValidated) {
      return Container(
        key: const ValueKey('validated'),
        height: buttonHeight,
        alignment: Alignment.center,
        child: Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
      );
    } else {
      return SizedBox(
        height: buttonHeight,
        child: ElevatedButton(
          key: const ValueKey('validate'),

          onPressed: () {
            setState(() {
              isValidated = true;
            });
            widget.onPressed?.call();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            minimumSize: Size.zero,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Valider',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
    }
  }
}
