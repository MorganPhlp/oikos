import 'package:flutter/material.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/number_input.dart';

class QuestionNumberWrapper extends StatefulWidget {
  final QuestionBilanEntity question;
  final int initialValue;
  final Function(int) onValidSubmit; 
  final Function(bool) onValidityChange;

  const QuestionNumberWrapper({
    super.key,
    required this.question,
    required this.initialValue,
    required this.onValidSubmit,
    required this.onValidityChange,
  });

  @override
  State<QuestionNumberWrapper> createState() => _QuestionNumberWrapperState(); 
}

class _QuestionNumberWrapperState extends State<QuestionNumberWrapper> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int _currentValue;
  bool _isInputEmpty = true;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant QuestionNumberWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _currentValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          OikosNumberInput(
            key: ValueKey(widget.question.slug), 
            
            value: _currentValue,
            unit: widget.question.unit ?? '',
            
            onChanged: (newValue) { // newValue est de type int
              setState(() { 
                _currentValue = newValue; 
                _isInputEmpty = newValue == 0;
              });

              final isFormValid = _formKey.currentState?.validate() ?? false; 
              final isFieldEmpty = _isInputEmpty;
              widget.onValidityChange(isFormValid && !isFieldEmpty); 

              if (isFormValid && !isFieldEmpty) {
                widget.onValidSubmit(newValue);
              }
            },
            
            min: widget.question.config['min'] != null 
                 ? (widget.question.config['min'] as num).toInt() : null,
            max: widget.question.config['max'] != null 
                 ? (widget.question.config['max'] as num).toInt() : null,
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}