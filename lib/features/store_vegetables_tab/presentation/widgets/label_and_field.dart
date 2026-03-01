import 'package:flutter/material.dart';

class LabelAndField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final bool isRequired;

  const LabelAndField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.inputType = TextInputType.text,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<LabelAndField> createState() => _LabelAndFieldState();
}

class _LabelAndFieldState extends State<LabelAndField> {
  String? _errorText;

  void _validate() {
    final text = widget.controller?.text ?? '';

    String? error;
    if (widget.isRequired && text.isEmpty) {
      error = '${widget.label} is required';
    } else if (widget.validator != null) {
      error = widget.validator!(text);
    }

    setState(() => _errorText = error);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: Color.fromARGB(255, 138, 138, 138),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _errorText != null ? Colors.red : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _errorText != null ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _errorText != null ? Colors.red : Colors.blue,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            _errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 10),
          ),
        ],
      ],
    );
  }
}
