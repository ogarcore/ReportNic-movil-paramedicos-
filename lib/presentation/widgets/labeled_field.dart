import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final String? Function(String?) validator;
  final String? value;
  final bool submitted;


  const LabeledField({
    required this.label,
    required this.child,
    required this.validator,
    required this.value,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = submitted ? validator(value) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        child,
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 6),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
          
      ],
    );
  }
}
