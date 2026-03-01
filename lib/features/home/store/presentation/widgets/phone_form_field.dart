import 'package:flutter/material.dart';

import 'custom_text_field.dart';


class PhoneFormField extends StatelessWidget {
  const PhoneFormField({
    super.key,
    required this.controller,
    this.hint = 'Enter mobile number',
    this.prefixText = '91 ',
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final String prefixText;
  final String? Function(String?)? validator;

  String? _defaultValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final clean = v.trim();
    if (clean.length != 10) {
      return 'Enter a valid 10-digit number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: hint,
      keyboardType: TextInputType.phone,
      prefixText: prefixText,
      prefixStyle: const TextStyle(color: Colors.black87, fontSize: 14),
      validator: validator ?? _defaultValidator,
    );
  }
}
