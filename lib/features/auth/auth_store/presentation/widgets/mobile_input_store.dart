import 'package:flutter/material.dart';

class MobileInput extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> val;

  const MobileInput({
    super.key,
    required this.controller,
    required this.val,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      child: TextFormField(
        controller: controller,
        validator: val,
        keyboardType: TextInputType.number,
        maxLength: 10,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: const Icon(Icons.phone_outlined, size: 18),
          prefixText: "+91 ",
          prefixStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          hintText: "Mobile Number",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}