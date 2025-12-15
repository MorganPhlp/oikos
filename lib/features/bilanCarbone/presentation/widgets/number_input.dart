import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oikos/core/theme/app_colors.dart';

class OikosNumberInput extends StatefulWidget {
  final int? value;
  final String? unit;
  final ValueChanged<int> onChanged;
  final int? min;
  final int? max;

  const OikosNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.unit,
    this.min,
    this.max,
  });

  @override
  State<OikosNumberInput> createState() => _OikosNumberInputState();
}

class _OikosNumberInputState extends State<OikosNumberInput> {
  late TextEditingController _controller;

  String _getInitialText() {
    if (widget.value == null) return '';
    if (widget.value! <= 0 && widget.min != null && widget.min! > 0) return '';
    return widget.value!.toString();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _getInitialText());
  }

  @override
  void didUpdateWidget(covariant OikosNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newText = _getInitialText();
      if (_controller.text != newText) {
        _controller.text = newText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextPrimary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          final number = int.tryParse(value);
          if (number == null) return 'Veuillez entrer un nombre valide.';
          if (widget.min != null && number < widget.min!) return 'La valeur minimale est ${widget.min}.';
          if (widget.max != null && number > widget.max!) return 'La valeur maximale est ${widget.max}.';
          return null;
        },
        onChanged: (val) {
          if (val.isEmpty) {
            widget.onChanged(0);
            return;
          }
          final number = int.tryParse(val);
          if (number != null) widget.onChanged(number);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.lightInput,
          hintText: '0',
          hintStyle: TextStyle(color: AppColors.lightTextPrimary.withOpacity(0.3)),
          suffixText: widget.unit,
          suffixStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextPrimary,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.lightInputBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.gradientGreenEnd, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.darkDestructive, width: 2.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.darkDestructive, width: 2.5),
          ),
          errorStyle: const TextStyle(color: AppColors.darkDestructive, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
